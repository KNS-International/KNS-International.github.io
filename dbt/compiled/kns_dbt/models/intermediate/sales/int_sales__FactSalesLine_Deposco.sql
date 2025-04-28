


with

params as (
    select dateadd(day, -10, current_timestamp) as last_update
),

orders_to_pull as (

    select
        oh.OrderHeaderId
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" as oh
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" as ol
        on oh.OrderHeaderId = ol.OrderHeaderId
    left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__CoLine" as cl
        on ol.CoLineId = cl.CoLineId
    
    cross join params
    where
        (oh.UpdatedDate >= params.last_update or
        ol.UpdatedDate >= params.last_update or
        cl.UpdatedDate >= params.last_update)
        and
        (select max(v) from (values(oh.UpdatedDate), (ol.UpdatedDate), (cl.UpdatedDate)) as value(v)) > params.last_update
    

),

order_line_list as (

    select
        concat('Deposco/', cast(ol.OrderLineId as varchar)) as [Number],
        ol.ItemId,
        oh.ConsigneePartnerId as TradingPartnerId,
        coalesce(ol.OrderPackQuantity * ol.UnitCost, 0) as Amount,
        coalesce(ol.OrderPackQuantity, 0) as Quantity,
        oh.CustomerOrderNumber as PoNumber,
        oh.KnsMtPlacedDate as PlacedDate,
        oh.KnsMtCreatedDate as CreatedDate,
        coalesce(oh.KnsMtPlannedReleaseDate, oh.KnsMtPlannedShipDate) as ContractualShipDate,
        oh.KnsMtPlannedShipDate as PlannedShipDate,
        oh.KnsMtActualShipDate as ActualShipDate,
        oh.CurrentStatus as HeaderCurrentStatus,
        case 
            when oh.ShippingStatus = '0' then 'Not Shipped'
            when oh.ShippingStatus = '10' then 'Partially Shipped'
            else 'Shipped'
        end as HeaderShippingStatus,
        ol.OrderLineStatus as LineStatus,
        coalesce(ol.OrderPackQuantity * tp.TaxRate, 0) as HandlingFee,
        null as Season
    from orders_to_pull q
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh 
      on oh.OrderHeaderId = q.OrderHeaderId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol 
      on ol.OrderHeaderId = oh.OrderHeaderId
    left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__CoLine" cl 
      on cl.CoLineId = ol.CoLineId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__TradingPartner" tp 
      on tp.TradingPartnerId = oh.ConsigneePartnerId
    where oh.Type = 'Sales Order'
      and (oh.OrderSource is null or oh.OrderSource not in (
           'Shipped Sales', 'Forecast Sales', 'Montly Net Revenue Percent',
           'Net Margin', 'Net Revenue Forecast', 'InvalidSource', 
           'Potential Sales', 'Amazon FBA', 'Walmart WFS'))
      and (oh.CustomerOrderNumber is null or oh.CustomerOrderNumber not like 'FBA%')
      and tp.Name != '- No Customer/Project -'

),

filtered as (

    select 
        * 
    from order_line_list
    where not (
        HeaderShippingStatus = 'Shipped'
        and ItemId != 153085
        and LineStatus not in ('Complete', 'Canceled', 'Closed')
    )

),

deduped_ranked as (

    select 
        f.*,
        ROW_NUMBER() OVER (
            PARTITION BY f.Number 
            ORDER BY case when f.LineStatus = 'Complete' then 0 else 1 end
        ) as rn,
        case 
            when di.Parent = 'Shipping Protection' then
                ROW_NUMBER() OVER (
                    PARTITION BY oh.OrderHeaderId, f.ItemId 
                    ORDER BY case when f.LineStatus = 'Complete' then 0 else 1 end
                )
            else 1
        end as shipping_protection_row
    from filtered f
    left join "KNSDevDbt"."dbt_prod_marts"."DimItem" di 
        on di.ItemId = f.ItemId
    left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol 
        on ol.OrderLineId = cast(replace(f.Number, 'Deposco/', '') as int)
    left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh 
        on oh.OrderHeaderId = ol.OrderHeaderId
),


deduped as (
    select *
    from deduped_ranked
    where rn = 1
      and shipping_protection_row = 1
),

update_order_protection as (
    select
        fs.Number,
        oh.CoHeaderId as ChId
    from deduped fs
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Item" i 
        on i.ItemId = fs.ItemId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol 
        on ol.OrderLineId = cast(replace(fs.Number, 'Deposco/', '') as int)
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh 
        on oh.OrderHeaderId = ol.OrderHeaderId
    where i.Name = 'Order Protection'
        and coalesce(i.ClassType, '') = ''
        and fs.Number like 'Deposco/%'
),

ch_ids as (
    select
        fs.Number,
        oh.CoHeaderId as ChId,
        di.BrandId
    from deduped fs
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol 
        on ol.OrderLineId = cast(replace(fs.Number, 'Deposco/', '') as int)
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh 
        on oh.OrderHeaderId = ol.OrderHeaderId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Item" i 
        on i.ItemId = fs.ItemId
    join "KNSDevDbt"."dbt_prod_marts"."DimItem" di 
        on di.ItemId = i.ItemId
    where fs.Number like 'Deposco/%'
        and coalesce(i.Name, '') != 'Order Protection'
),

final_mapping as (
    select 
        o.Number,
        min(c.BrandId) as BrandId
    from update_order_protection o
    join ch_ids c 
        on c.ChId = o.ChId
    group by o.Number
),

shipping_protection as (
    select 
        i.ItemId,
        i.BrandId
    from "KNSDevDbt"."dbt_prod_marts"."DimItem" i
    where i.Parent = 'Shipping Protection'
),

final as (
    select 
        d.Number,
        case 
            when sp.ItemId is not null and d.ItemId <> sp.ItemId then sp.ItemId
            else d.ItemId
        end as ItemId,
        d.TradingPartnerId,
        d.Amount,
        d.Quantity,
        d.PoNumber,
        d.PlacedDate,
        d.CreatedDate,
        d.ContractualShipDate,
        d.PlannedShipDate,
        d.ActualShipDate,
        d.HeaderCurrentStatus,
        d.HeaderShippingStatus,
        d.LineStatus,
        d.HandlingFee,
        d.Season
    from deduped d
    left join final_mapping fm 
        on fm.Number = d.Number
    left join shipping_protection sp 
        on sp.BrandId = fm.BrandId
)

select * from final