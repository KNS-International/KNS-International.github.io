
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "Deposco"."DimPLD__dbt_tmp__dbt_tmp_vw" as 
  


with

date_variable as (
    select 
        dateadd(year, -1, cast(getdate() as date)) as one_year_ago,
        dateadd(month, -2, cast(getdate() as date)) as two_months_ago
),

item as (
    select
        ItemId,
        Number 
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__DimItemPrep"
),

trading_partner as (
    select
        TradingPartnerId,
        Name
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__TradingPartner"
),

price_list as (
    select
        PriceListId,
        TradingPartnerId
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__PriceList"
),

price_list_detail as (
    select
        PriceListId,
        ItemId,
        SalesPrice,
        SalesEffectiveStart,
        SalesEffectiveEnd
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__PriceListDetail"
),

pld_combined as (
    select
        pld.ItemId,
        pld.SalesPrice,
        pld.SalesEffectiveStart,
        pld.SalesEffectiveEnd,
        pl.TradingPartnerId
    from price_list_detail pld
    join price_list pl on pld.PriceListId = pl.PriceListId
),

sales as (
    select
        Number,
        PONumber,
        ItemId,
        TradingPartnerId,
        cast(Amount as decimal(18,2)) / nullif(Quantity,0) as SalesPrice,
        Quantity,
        PlacedDate
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco"
),

final as (
    select
        s.Number as FactSalesLineNumber,
        s.PONumber,
        i.Number as SKU,
        tp.Name as TradingPartnerName,
        pld.SalesPrice as ActivePLD,
        s.SalesPrice as SalesPrice,
        s.Quantity,
        s.PlacedDate as PlacedAt,
        pld.SalesEffectiveStart as PLDEffectiveStart,
        pld.SalesEffectiveEnd as PLDEffectiveEnd
    from sales s 
    join item i on s.ItemId = i.ItemId
    join pld_combined pld on i.ItemId = pld.ItemId
        and s.TradingPartnerId = pld.TradingPartnerId
        and pld.SalesEffectiveStart <= s.PlacedDate
        and iif(pld.SalesEffectiveEnd is not null, 
                pld.SalesEffectiveEnd, 
                ''3025-01-01'') 
            >= s.PlacedDate
    join trading_partner tp on s.TradingPartnerId = tp.TradingPartnerId

)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."Deposco"."DimPLD__dbt_tmp" FROM "KNSDataWarehouse"."Deposco"."DimPLD__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS Deposco.DimPLD__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'Deposco_DimPLD__dbt_tmp_cci'
        AND object_id=object_id('Deposco_DimPLD__dbt_tmp')
    )
    DROP index "Deposco"."DimPLD__dbt_tmp".Deposco_DimPLD__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX Deposco_DimPLD__dbt_tmp_cci
    ON "Deposco"."DimPLD__dbt_tmp"

   


  