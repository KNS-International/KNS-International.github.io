

with

params as (
    select dateadd(day, -10, current_timestamp) as last_update
),

orders_to_pull as (

    select
        oh.OrderHeaderId
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__OrderHeader" as oh
    join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__OrderLine" as ol
        on oh.OrderHeaderId = ol.OrderHeaderId
    left join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__CoLine" as cl
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
    join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__OrderHeader" oh 
      on oh.OrderHeaderId = q.OrderHeaderId
    join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__OrderLine" ol 
      on ol.OrderHeaderId = oh.OrderHeaderId
    left join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__CoLine" cl 
      on cl.CoLineId = ol.CoLineId
    join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__TradingPartner" tp 
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

)

select * from filtered