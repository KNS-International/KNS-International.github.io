
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_marts"."FactMarketingAd__dbt_tmp__dbt_tmp_vw" as with 

brands as (
    select * from "KNSDevDbt"."tlawson"."seed_brands"
),

marketing_data as (

    select * from "KNSDevDbt"."dbt_tlawson_intermediate"."int_marketing__SourcesMapped"

),

final as (
    select 
        m.[Date],
        m.[AdName],
        m.[AdSet],
        m.[Campaign],
        m.TradingPartnerId,
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
        cast(SalesDollars as decimal(19, 4)) as SalesDollars,
        cast(SalesUnits as decimal(19, 4)) as SalesUnits

    from marketing_data m
    left join brands b 
        on b.Brand = m.BrandMapping
    where TradingPartnerId is not null
)

select * from final;;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_tlawson_marts"."FactMarketingAd__dbt_tmp" FROM "KNSDevDbt"."dbt_tlawson_marts"."FactMarketingAd__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_tlawson_marts.FactMarketingAd__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_tlawson_marts_FactMarketingAd__dbt_tmp_cci'
        AND object_id=object_id('dbt_tlawson_marts_FactMarketingAd__dbt_tmp')
    )
    DROP index "dbt_tlawson_marts"."FactMarketingAd__dbt_tmp".dbt_tlawson_marts_FactMarketingAd__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_tlawson_marts_FactMarketingAd__dbt_tmp_cci
    ON "dbt_tlawson_marts"."FactMarketingAd__dbt_tmp"

   


  