USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_intermediate"."int_sales__ReturnRatePrep__dbt_tmp" as with

params as (
    select 
        dateadd(year, -1, getdate()) as returns_after
),

accepted_tp as (

    select
        Code,
        TradingPartnerId,
        Name
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__TradingPartner"
    where ContactEmail = ''TRUE''
        and Name != ''MARKETING''

),

customer_blind_returns as (

    select
        case 
            when oh.ConsigneePartnerId is not null
                then (select name from accepted_tp tp where oh.ConsigneePartnerId = tp.TradingPartnerId)
            else
                (select name from accepted_tp tp where oh.Seller = tp.Code)
        end as TradingPartner,
        i.StyleNumber as Parent,
        concat(i.StyleNumber, ''-'', i.ColorName) as Item,
        null as PurchasedQuantity,
        rl.ReceivedPackQuantity as ReturnQuantity,
        datediff(day,
                cast((select poh.CreatedDate
                    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" poh
                    where oh.ParentOrderId = poh.OrderHeaderId) as date),
                cast(oh.CreatedDate as date)
        ) as ReturnDays
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__ReceiptLine" rl
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol 
        on rl.OrderLineId = ol.OrderLineId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh
        on ol.OrderHeaderId = oh.OrderHeaderId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Item" i
        on ol.ItemId = i.ItemId
    cross join params
    where oh.Type in (''Blind RMA'', ''Customer Return'')
        and (oh.Seller in (select Code from accepted_tp) 
            or oh.ConsigneePartnerId in (select TradingPartnerId from accepted_tp))
        and oh.CreatedDate > params.returns_after
        and i.StyleNumber is not null
        and i.ColorName is not null

),

sales_order_returns as (

    select
        case 
            when oh.ConsigneePartnerId is not null
                then (select name from accepted_tp tp where oh.ConsigneePartnerId = tp.TradingPartnerId)
            else
                (select name from accepted_tp tp where oh.Seller = tp.Code)
        end as TradingPartner,
        i.StyleNumber as Parent,
        concat(i.StyleNumber, ''-'', i.ColorName) as Item,
        OrderPackQuantity as PurchasedQuantity,
        null as ReturnedQuantity,
        null as ReturnDays
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol 
        on oh.OrderHeaderId = ol.OrderHeaderId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Item" i
        on ol.ItemId = i.ItemId
    cross join params
    where oh.Type = ''Sales Order''
        and (oh.OrderSource is null or oh.OrderSource not in 
            (''Shipped Sales'', ''Forecast Sales'', ''Montly Net Revenue Percent'', ''Net Margin'', ''Net Revenue Forecast'', ''InvalidSource'', ''Potential Sales'', ''Amazon FBA'', ''Walmart WFS'')
            )
        and oh.CurrentStatus != ''Voided''
        and (oh.CustomerOrderNumber is null or oh.CustomerOrderNumber not like ''FBA%'')
        and (ol.OrderLineStatus != ''Canceled'')
        and (oh.Seller in (select Code from accepted_tp) 
            or oh.ConsigneePartnerId in (select TradingPartnerId from accepted_tp))
        and oh.CreatedDate > dateadd(month, -1, params.returns_after)
        and oh.CreatedDate < dateadd(month, -1, getdate())
        and i.StyleNumber is not null
        and i.ColorName is not null

),

returns_unioned as (

    select * from customer_blind_returns
    union all
    select * from sales_order_returns

)

select * from returns_unioned;
    ')

