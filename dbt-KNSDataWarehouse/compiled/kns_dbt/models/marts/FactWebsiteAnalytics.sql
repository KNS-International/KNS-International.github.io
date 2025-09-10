with

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

select * from final