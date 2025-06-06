
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactSalesLine__dbt_tmp__dbt_tmp_vw" as 
  


with

returns_accruals as (
  select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_ReturnsAccruals"
),

deposco as (
    select 
        *
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco" 
),

unioned as (
    select 
        cast(Number as nvarchar(200)) as Number,
        cast(ItemId as int) as ItemId,
        cast(TradingPartnerId as int) as TradingPartnerId,
        cast(Brand as nvarchar(200)) as Brand,
        cast(LastUpdatedAt as datetime) as LastUpdatedAt,
        cast(Amount as decimal(19, 4)) as Amount,
        cast(Quantity as int) as Quantity,
        cast(PONumber as nvarchar(64)) as PONumber,
        cast(PlacedDate as datetime) as PlacedDate,
        cast(CreatedDate as datetime) as CreatedDate,
        cast(ContractualShipDate as datetime) as ContractualShipDate,
        cast(PlannedShipDate as datetime) as PlannedShipDate,
        cast(ActualShipDate as datetime) as ActualShipDate,
        cast(HeaderCurrentStatus as nvarchar(48)) as HeaderCurrentStatus,
        cast(HeaderShippingStatus as nvarchar(48)) as HeaderShippingStatus,
        cast(LineStatus as nvarchar(48)) as LineStatus,
        cast(FreightOutCOGS as decimal(19, 4)) as FreightOutCOGS,
        cast(ItemCOGS as decimal(19, 4)) as ItemCOGS,
        cast(HandlingFee as decimal(19, 4)) as HandlingFee,
        cast(DiscountAmount as decimal(19, 4)) as DiscountAmount,
        cast(RecordUpdatedAt as datetime) as RecordUpdatedAt,
        cast(Season as nvarchar(32)) as Season 
    from deposco
    union all
    select 
        cast(Number as nvarchar(200)) as Number,
        cast(ItemId as int) as ItemId,
        cast(TradingPartnerId as int) as TradingPartnerId,
        cast(Brand as nvarchar(200)) as Brand,
        cast(LastUpdatedAt as datetime) as LastUpdatedAt,
        cast(Amount as decimal(19, 4)) as Amount,
        cast(Quantity as int) as Quantity,
        cast(PONumber as nvarchar(64)) as PONumber,
        cast(PlacedDate as datetime) as PlacedDate,
        cast(CreatedDate as datetime) as CreatedDate,
        cast(ContractualShipDate as datetime) as ContractualShipDate,
        cast(PlannedShipDate as datetime) as PlannedShipDate,
        cast(ActualShipDate as datetime) as ActualShipDate,
        cast(HeaderCurrentStatus as nvarchar(48)) as HeaderCurrentStatus,
        cast(HeaderShippingStatus as nvarchar(48)) as HeaderShippingStatus,
        cast(LineStatus as nvarchar(48)) as LineStatus,
        cast(FreightOutCOGS as decimal(19, 4)) as FreightOutCOGS,
        cast(ItemCOGS as decimal(19, 4)) as ItemCOGS,
        cast(HandlingFee as decimal(19, 4)) as HandlingFee,
        cast(DiscountAmount as decimal(19, 4)) as DiscountAmount,
        cast(RecordUpdatedAt as datetime) as RecordUpdatedAt,
        cast(Season as nvarchar(32)) as Season 
    from returns_accruals
),

final as (
    select
        *
    from unioned
    where PlacedDate >= datefromparts(year(getdate()) - 2, 1, 1)
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactSalesLine__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactSalesLine__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactSalesLine__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactSalesLine__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactSalesLine__dbt_tmp')
    )
    DROP index "KNS"."FactSalesLine__dbt_tmp".KNS_FactSalesLine__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactSalesLine__dbt_tmp_cci
    ON "KNS"."FactSalesLine__dbt_tmp"

   


  