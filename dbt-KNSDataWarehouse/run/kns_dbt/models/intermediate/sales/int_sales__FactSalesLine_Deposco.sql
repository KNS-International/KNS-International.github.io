USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco__dbt_tmp" as with 

update_order_protection as (
    select
        ol.OrderLineId as Number,
        oh.CoHeaderId as ChId
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Item" i 
        on i.ItemId = ol.ItemId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh 
        on oh.OrderHeaderId = ol.OrderHeaderId
    where i.Name = ''Order Protection''
        and coalesce(i.ClassType, '''') = ''''
),

ch_ids as (
    select
        ol.OrderLineId as Number,
        oh.CoHeaderId as ChId,
        di.BrandId
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol 
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh 
        on oh.OrderHeaderId = ol.OrderHeaderId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Item" i 
        on i.ItemId = ol.ItemId
    join "KNSDataWarehouse"."Deposco"."DimItem" di 
        on di.ItemId = i.ItemId
    where coalesce(i.Name, '''') != ''Order Protection''
),

order_protection_mapping as (
    select 
        o.Number,
        max(c.BrandId) as BrandId
    from update_order_protection o
    join ch_ids c 
        on c.ChId = o.ChId
    group by o.Number
),

order_protection_item as (
    select 
        i.ItemId,
        i.BrandId
    from "KNSDataWarehouse"."Deposco"."DimItem" i
    where i.ItemId in (
        204260
        ,204261
        ,204262
        ,212170
    )
),

sales_order as (
    select
        SalesOrderId,
        PONumber,
        TradingPartnerId,
        PlacedAt,
        ContractualShipAt,
        PlannedShipAt,
        Status,
        ShippedAt,
        FreightOutCOGSAmount,
        DiscountAmount
    from "KNSDevDbt"."dbt_prod_staging"."stg_orders__SalesOrder"
),

sales_order_line as (
    select
        sol.SalesOrderLineId,
        sol.SalesOrderId,
        sol.SourceId,
        sol.ItemId,
        sol.ProductVariantId,
        case
            when so.Status = ''closed'' then sol.QuantityShipped
            else sol.QuantityOrdered
        end as Quantity,
        sol.UnitCostAmount,
        sol.UnitItemCOGSAmount,
        sol.QuantityShipped
    from "KNSDevDbt"."dbt_prod_staging"."stg_orders__SalesOrderLine" sol
    left join sales_order so
    on sol.SalesOrderId = so.SalesOrderId
),

-- THIS SHOULD BE RENAMED TO TRADING_PARTNER AFTER FIXING THE TRADING PARTNER ID
mdm_trading_partner as (
    select
        TradingPartnerId,
        Name
    from "KNSDevDbt"."dbt_prod_staging"."stg_orders__TradingPartner"
),

-- trading_partner_handling_fee as (
--     select
--         TradingPartnerId,
--         StartDate,
--         EndDate,
--         HandlingFeeType,
--         HandlingFee
--     from "KNSDevDbt"."dbt_prod_staging"."stg_orders__TradingPartnerHandlingFee"
-- ),

trading_partner as (
    select
        TradingPartnerId,
        Name,
        TaxRate
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__TradingPartner"
),

joined as (
    select
        cast(concat(''Deposco/'', sol.SourceId) as nvarchar(255)) as Number,
        case 
            when opi.ItemId is not null and sol.ItemId != opi.ItemId then opi.ItemId
            else sol.ItemId
        end as ItemId,
        tp.TradingPartnerId,
        b.Name as Brand,
        null as LastUpdatedAt,
        sol.Quantity*sol.UnitCostAmount as Amount,
        sol.Quantity,
        so.PONumber,
        so.PlacedAt as PlacedDate,
        so.PlacedAt as CreatedDate,
        so.ContractualShipAt as ContractualShipDate,
        so.PlannedShipAt as PlannedShipDate,
        so.ShippedAt as ActualShipDate,
        case
            when so.Status = ''open'' then ''New''
            when so.Status = ''closed'' then ''Complete''
            else null
        end as HeaderCurrentStatus,
        case
            when so.Status = ''open'' then ''Not Shipped''
            when so.Status = ''closed'' then ''Shipped''
            else null
        end as HeaderShippingStatus,
        case
            when so.Status = ''open'' then ''New''
            when so.Status = ''closed'' then ''Complete''
            else null
        end as LineStatus,
        convert(decimal(19,4),
            (cast(sol.Quantity as decimal(19,4)) / 
            nullif(sum(coalesce(sol.Quantity, 0)) over (partition by sol.SalesOrderId), 0)) 
            * so.FreightOutCOGSAmount
        ) as FreightOutCOGS,
        sol.UnitItemCOGSAmount*sol.Quantity as ItemCOGS,
        -- case
        --     when tphf.HandlingFeeType = ''Order'' 
        --         then tphf.HandlingFee
        --     when tphf.HandlingFeeType = ''Unit'' 
        --         then tphf.HandlingFee*sol.Quantity
        --     else null
        -- end as HandlingFee,

        -- DELETE THE FOLLOWING LINE WHEN FIXING TRADING PARTNER ID 
        coalesce(sol.Quantity * tp.TaxRate, 0) as HandlingFee,

        convert(decimal(19,4),
            (cast(sol.Quantity as decimal(19,4)) / 
            nullif(sum(coalesce(sol.Quantity, 0)) over (partition by sol.SalesOrderId), 0)) 
            * so.DiscountAmount
        ) as DiscountAmount,
        null as RecordUpdatedAt,
        null as season
    from sales_order_line sol
    left join sales_order so
    on sol.SalesOrderId = so.SalesOrderId
    
    -- THIS SECTION ALSO NEEDS TO BE CHANGED BACK TO ONLY USING THE MDM TRADING PARTNER TABLE
    left join mdm_trading_partner mtp
    on so.TradingPartnerId = mtp.TradingPartnerId
    left join trading_partner tp
    on mtp.Name = tp.Name
    -- left join trading_partner_handling_fee tphf
    -- on so.TradingPartnerId = tphf.TradingPartnerId
    --     and so.PlacedAt >= tphf.StartDate
    --     and (so.PlacedAt <= tphf.EndDate or tphf.EndDate is null)
    left join order_protection_mapping opm
    on cast(sol.SourceId as nvarchar(200)) = cast(opm.Number as nvarchar(200))
    left join order_protection_item opi
    on opm.BrandId = opi.BrandId
    left join "KNSDataWarehouse"."Deposco"."DimItem" di 
    on sol.ItemId = di.ItemId
    left join "KNSDevDbt"."dbt_prod_staging"."stg_products__Brand" b
    on di.BrandId = b.BrandId
    where tp.Name not in (
        ''Marketing'',
        ''- No Customer/Project -''
    )
),

depsco_filters as (
    select
        j.*
    from joined j
    where (j.PONumber is null 
            or j.PONumber not like ''FBA%'')
        and not (j.HeaderShippingStatus = ''Shipped'' 
            and j.ItemId = 153085
            and j.LineStatus != ''Complete'')
),

final as (
    select
        Number,
        ItemId,
        TradingPartnerId,
        Brand,
        LastUpdatedAt,
        Amount,
        Quantity,
        PONumber,
        PlacedDate,
        CreatedDate,
        ContractualShipDate,
        PlannedShipDate,
        ActualShipDate,
        HeaderCurrentStatus,
        HeaderShippingStatus,
        LineStatus,
        FreightOutCOGS,
        ItemCOGS,
        HandlingFee,
        DiscountAmount,
        RecordUpdatedAt,
        Season
    from depsco_filters
)

select * from final;
    ')

