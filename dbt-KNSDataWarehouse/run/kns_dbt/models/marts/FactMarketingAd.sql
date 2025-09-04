
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactMarketingAd__dbt_tmp__dbt_tmp_vw" as 
  


with 

brands as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_products__Brand"
),

trading_partners as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_orders__TradingPartner"
),

marketing_data as (

    select * from "KNSDevDbt"."dbt_prod_intermediate"."int_marketing__SourcesMapped"

),

final as (
    select 
        m.[Date],
        m.[AdName],
        m.[AdSet],
        m.[Campaign],
        coalesce(tp.TradingPartnerId, m.TradingPartnerId) as TradingPartnerId,
        m.[Platform],
        m.Channel,
        m.Type,
        b.BrandId,
        m.ObjectiveMapped as Objective,
        m.LandingPageMapped as LandingPage,
        m.ParsedClass1 as Class1,
        m.ParsedClass2 as Class2,
        m.ParsedClass3 as Class3,
        cast(Spend as decimal(19, 4)) as Spend,
        cast(ClickThrough as decimal(19, 4)) as ClickThrough,
        cast(Impressions as decimal(19, 4)) as Impressions,
        cast(Conversions as decimal(19, 4)) as Conversions,
        cast(SalesDollars as decimal(19, 4)) as AttributedRevenue,
        cast(SalesUnits as decimal(19, 4)) as SalesUnits

    from marketing_data m
    left join brands b 
        on b.Name = m.BrandMapping
    left join trading_partners tp
        on tp.Code = m.TradingPartnerCode
)

select * from final
    where TradingPartnerId is not null
    and Date >= dateadd(year, -1, getdate())
    and (Spend > 0 or AttributedRevenue > 0);;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactMarketingAd__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactMarketingAd__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactMarketingAd__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactMarketingAd__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactMarketingAd__dbt_tmp')
    )
    DROP index "KNS"."FactMarketingAd__dbt_tmp".KNS_FactMarketingAd__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactMarketingAd__dbt_tmp_cci
    ON "KNS"."FactMarketingAd__dbt_tmp"

   


  