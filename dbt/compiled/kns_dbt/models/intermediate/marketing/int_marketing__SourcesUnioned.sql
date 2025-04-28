with 

criteo as (

    select 
        Date,
        'Criteo-Ad' as AdName,
        'Criteo-Ad-Set' as AdSet,
        CampaignName as Campaign,
        tp.TradingPartnerId as TradingPartnerId,
        'Criteo' as Platform,
        null as Channel,
        null as Type,
        null as Brand,
        Spend,
        ctr as ClickThrough,
        impressions as Impressions,
        ctr * impressions as Conversions,
        attributedSales as SalesDollars,
        attributedUnits as SalesUnits
    from "KNSDevDbt"."dbt_prod_staging"."stg_marketing__Criteo" c
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__TradingPartner" tp
        on c.retailerName = tp.Name
    where Spend > 0

),

northbeam as (
    select 
        Date,
        ad_name as AdName,
        adset_name as AdSet,
        campaign_name as Campaign,
        null as TradingPartnerId,
        'Northbeam' as Platform,
        breakdown_platform_northbeam as Channel,
        null as Type,
        null as Brand,
        Spend,
        --visits / nullif(imprs, 0) as ClickThrough, CHECK IF CTR MEANS WHAT IT ALSO MEANS IN CRITEO
        ctr as ClickThrough,
        imprs as Impressions,
        --visits * 1 / nullif(imprs, 0) * imprs as Conversions,
        ctr * imprs as Conversions,
        attributed_rev as SalesDollars,
        null as SalesUnits
    from "KNSDevDbt"."dbt_prod_staging"."stg_marketing__Northbeam" 
    where attribution_model = 'Clicks and views'
        and attribution_window = '7'
),

promoteiq as (
    select 
        Date,
        'PromoteIQ-Ad' as AdName,
        'PromoteIQ-Ad-Set' as AdSet,
        [Campaign Name] as Campaign,
        13 as TradingPartnerId,
        'PromoteIQ' as Platform,
        null as Channel,
        null as Type,
        null as Brand,
        Spend,
        CTR as ClickThrough,
        Impressions,
        CTR * Impressions as Conversions,
        [Total Sales] as SalesDollars,
        [Units Sold] as SalesUnits
    from "KNSDevDbt"."dbt_prod_staging"."stg_marketing__PromoteIq" p
    where ([Vendor Name] like '%JOURNEE%' or [Vendor Name] like '%VANCE%')
        and p.[Campaign Name] is not null
),

symbiosys as (
    select 
        Date,
        'Symbiosys-Ad' as AdName,
        'Symbiosys-Ad-Set' as AdSet,
        Campaign as Campaign,
        3 as TradingPartnerId,
        'Symbiosys' as Platform,
        Channel,
        null as Type,
        null as Brand,
        Spend,
        null as ClickThrough,
        null as Impressions,
        null as Conversions,
        Sales as SalesDollars,
        [Units Sold] as SalesUnits
    from "KNSDevDbt"."dbt_prod_staging"."stg_marketing__Symbiosys"
),

coop_campaign as (
    select 
        cal.Date,
        'Co-Op-Campaigns-Ad' as AdName,
        'Co-Op-Campaigns-Ad-Set' as AdSet,
        FrontCode as Campaign,
        substring(substring(trim(BackCode), len(trim(BackCode)) - 20, 21), 1, 3) as TradingPartnerId,
        'Co-Op Campaigns' as Platform,
        null as Channel,
        null as Type,
        null as Brand,
        Spend / (
            select count(*) 
            from "KNSDevDbt"."dbt_prod_staging"."stg_dbo__Calendar" cal2 
            where cal2.Date >= co.StartAt and cal2.Date <= co.EndAt
        ) as Spend,
        null as ClickThrough,
        null as Impressions,
        null as Conversions,
        null as SalesDollars,
        null as SalesUnits
    from "KNSDevDbt"."dbt_prod_staging"."stg_marketing__CoOpCampaign" co
    join "KNSDevDbt"."dbt_prod_staging"."stg_dbo__Calendar" cal
        on cal.Date >= co.StartAt and cal.Date <= co.EndAt
),

roundel as (

    select 
        Date,
        'Roundel-Ad' as AdName,
        'Roundel-Ad-Set' as AdSet,
        campaignName as Campaign,
        62 as TradingPartnerId,
        platform as Platform,
        null as Channel,
        null as Type,
        brand as Brand,
        Spend,
        clicks / NULLIF(Impressions, 0) as ClickThrough, --CHECK THIS LOGIC
        Impressions,
        clicks as Conversions,
        attributedSales as SalesDollars,
        attributedUnits as SalesUnits
    from "KNSDevDbt"."dbt_prod_staging"."stg_marketing__Roundel"

),

sources_unioned as (
    select * from criteo
    union all
    select * from northbeam
    union all
    select * from promoteiq
    union all
    select * from symbiosys
    union all
    select * from coop_campaign
    union all
    select * from roundel
)

select * from sources_unioned;