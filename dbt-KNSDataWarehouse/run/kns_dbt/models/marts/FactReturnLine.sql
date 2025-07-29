
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactReturnLine__dbt_tmp__dbt_tmp_vw" as 
  


with

order_line as (
    select
        OrderLineId,
        OrderHeaderId,
        OrderPackQuantity,
        ItemId
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" 
),

order_header as (
    select
        OrderHeaderId,
        ConsigneePartnerId as TradingPartner,
        Type,
        KnsMtCreatedDate
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader"
),

item as (
    select
        ItemId,
        BrandId,
        Parent,
        Color
    from "KNSDataWarehouse"."Deposco"."DimItem"
),

trading_partner as (
    select
        TradingPartnerId,
        IsReturnsPartner
    from "KNSDevDbt"."dbt_prod_staging"."stg_orders__TradingPartner"
),

final as (
    select
        ol.OrderLineId,
        i.BrandId,
        tp.TradingPartnerId,
        oh.KnsMtCreatedDate as ReturnDate,
        ol.OrderPackQuantity as ReturnQuantity,
        i.ItemId,
        i.Parent,
        i.Color
    from order_line ol
    join order_header oh on ol.OrderHeaderId = oh.OrderHeaderId
    join item i on ol.ItemId = i.ItemId
    join trading_partner tp on oh.TradingPartner = tp.TradingPartnerId
    where oh.TYPE in (''Blind RMA'', ''Customer Return'')
    and oh.KnsMtCreatedDate > ''2023-01-01''
    and tp.IsReturnsPartner = 1
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactReturnLine__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactReturnLine__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactReturnLine__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactReturnLine__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactReturnLine__dbt_tmp')
    )
    DROP index "KNS"."FactReturnLine__dbt_tmp".KNS_FactReturnLine__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactReturnLine__dbt_tmp_cci
    ON "KNS"."FactReturnLine__dbt_tmp"

   


  