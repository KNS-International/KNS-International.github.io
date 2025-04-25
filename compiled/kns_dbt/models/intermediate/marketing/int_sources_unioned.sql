with 

criteo as (

    select 
        Date,
        'Criteo-Ad' as AdName,
        'Criteo-Ad-Set' as AdSet,
        CampaignName as Campaign,
        tp.TRADING_PARTNER_ID as TradingPartnerId,
        'Criteo' as Platform,
        NULL as Channel,
        NULL as Type,
        Spend,
        ctr as ClickThrough,
        impressions as Impressions,
        ctr*impressions as Conversions,
        attributedSales as SalesDollars,
        attributedUnits as SalesUnits
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_marketing__criteo" c
    join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__trading_partner" tp
    on c.retailerName = tp.NAME
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
        NULL as Type,
        Spend,
        visits / nullif(imprs, 0) as ClickThrough,
        imprs as Impressions,
        visits * 1/nullif(imprs,0) * imprs as Conversions,
        attributed_rev as SalesDollars,
        null as SalesUnits
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_marketing__northbeam" 
    where attribution_model = 'Clicks and views'
        AND attribution_window = '7'
)

select * from northbeam