USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_marketing__Roundel__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."marketing"."Roundel"

),

cleaned as (

    select 
        cast(event_day as date) as date,
        cast(campaign_name as nvarchar(128)) as campaignName,
        cast(adjusted_actualized_spend as decimal(19, 4)) as spend,
        cast(total_sales as decimal(19, 4)) as attributedSales,
        cast(total_units as decimal(19, 4)) as attributedUnits,
        cast(clicks as decimal(19, 4)) as clicks,
        cast(impressions as decimal(19, 4)) as impressions
    from source 
        
)

select * from cleaned;
    ')

