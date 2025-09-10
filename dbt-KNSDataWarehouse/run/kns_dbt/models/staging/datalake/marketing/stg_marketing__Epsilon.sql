USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_marketing__Epsilon__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."marketing"."Epsilon"

),

cleaned as (

    select 
        cast(ingressed_at as date) as Date,
        cast(campaign_id as nvarchar(255)) as CampaignId,
        cast(Instance as nvarchar(128)) as Brand,
        cast(ad_spend as decimal(19, 4)) as Spend,
        cast(sales_revenue as decimal(19, 4)) as SalesRevenue,
        cast(unit_sales as decimal(19, 4)) as UnitSales,
        cast(clicks as decimal(19, 4)) as Clicks,
        cast(impressions as decimal(19, 4)) as Impressions,
        cast(conversions as decimal(19, 4)) as Conversions
    from source 
        
)

select * from cleaned;
    ')

