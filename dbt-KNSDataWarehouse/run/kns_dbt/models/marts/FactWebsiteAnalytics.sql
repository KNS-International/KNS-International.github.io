
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_marts"."FactWebsiteAnalytics__dbt_tmp__dbt_tmp_vw" as with

google_analytics as (

    select
        Site,
        Date,
        SessionDefaultChannelGroup,
        CountryId,
        DeviceCategory,
        SessionSource,
        sum(Sessions) as Sessions
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__GoogleAnalyticsData"
    group by
        Site,
        Date,
        SessionDefaultChannelGroup,
        CountryId,
        DeviceCategory,
        SessionSource
    
),

trading_partner_id as (
    select
        ga.Date,
        tp.TradingPartnerId,
        ga.Site,
        ga.SessionDefaultChannelGroup,
        ga.CountryId,
        ga.DeviceCategory,
        ga.SessionSource,
        ga.Sessions
    from google_analytics ga
    left join "KNSDevDbt"."dbt_prod_staging"."stg_orders__TradingPartner" tp 
        on ga.Site = tp.Name
),

final as (
    select * from trading_partner_id
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_prod_marts"."FactWebsiteAnalytics__dbt_tmp" FROM "KNSDevDbt"."dbt_prod_marts"."FactWebsiteAnalytics__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_prod_marts.FactWebsiteAnalytics__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_prod_marts_FactWebsiteAnalytics__dbt_tmp_cci'
        AND object_id=object_id('dbt_prod_marts_FactWebsiteAnalytics__dbt_tmp')
    )
    DROP index "dbt_prod_marts"."FactWebsiteAnalytics__dbt_tmp".dbt_prod_marts_FactWebsiteAnalytics__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_prod_marts_FactWebsiteAnalytics__dbt_tmp_cci
    ON "dbt_prod_marts"."FactWebsiteAnalytics__dbt_tmp"

   


  