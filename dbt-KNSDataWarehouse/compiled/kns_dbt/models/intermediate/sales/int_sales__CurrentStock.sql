with

day_start as (
    select 
        convert(datetime, convert(date, sysdatetimeoffset() at time zone 'mountain standard time')) 
        at time zone 'mountain standard time' 
        at time zone 'utc' as day_start
),

order_header as (
    select 
        OrderHeaderId,
        ShippingStatus,
        CurrentStatus,
        CreatedDate,
        Type
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader"
),

order_line as (
    select 
        OrderLineId,
        OrderHeaderId,
        ItemId,
        PackId,
        OrderPackQuantity
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine"
),

pack as (
    select 
        PackId,
        Quantity
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Pack"
),

item as (
    select 
        ItemId,
        IntangibleItemFlag,
        ClassType
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Item"
),

ordered as (
    select
        ol.ItemId,
        coalesce(sum(ol.OrderPackQuantity * p.Quantity), 0) as TotalOrdered
    from order_line ol
    join pack p on ol.PackId = p.PackId
    join order_header oh on ol.OrderHeaderId = oh.OrderHeaderId
    where oh.ShippingStatus != 20
        and oh.CurrentStatus not in ('Hold', 'Canceled', 'Voided')
        and oh.CreatedDate >= dateadd(year, -1, 
        cast(sysdatetimeoffset() at time zone 'mountain standard time' as datetime))
        and oh.Type = 'Sales Order'
    group by ol.ItemId
),

stock_unit_unioned as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__StockUnit"
    union all
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__StockUnitAuditHistory"
),

current_stock as (
    select
        s.ItemId,
        coalesce(sum(s.Quantity * p.Quantity), 0) as Quantity,
        case 
            when coalesce(sum(s.Quantity * p.Quantity), 0) - coalesce(o.TotalOrdered, 0) < 0
                then 0
            else coalesce(sum(s.Quantity * p.Quantity), 0) - coalesce(o.TotalOrdered, 0)
        end as AvailableQuantity
    from stock_unit_unioned s
    join item i on s.ItemId = i.ItemId
    join pack p on s.PackId = p.PackId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Location" l on s.LocationId = l.LocationId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__LocationZones" lz on l.LocationId = lz.LocationId
    left join ordered o on o.ItemId = s.ItemId
    cross join day_start                      
    where i.IntangibleItemFlag = 0
      and s.PeriodStart <= day_start.day_start
      and s.PeriodEnd >= day_start.day_start
      and coalesce(i.ClassType, '') != 'Supplies'
    group by s.ItemId, o.TotalOrdered
)

select * from current_stock