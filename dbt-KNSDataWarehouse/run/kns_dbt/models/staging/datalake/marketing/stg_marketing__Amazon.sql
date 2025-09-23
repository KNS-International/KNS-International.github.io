USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_marketing__Amazon__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."marketing"."Amazon"

),

cleaned as (

    select 
        cast(date as date) as Date,
        cast(campaignId as nvarchar(255)) as CampaignId,
        cast(campaignName as nvarchar(255)) as CampaignName,
        cast(Instance as nvarchar(128)) as Brand,
        cast(cost as decimal(19, 4)) as Cost,
        cast(sales as decimal(19, 4)) as Sales,
        cast(clicks as decimal(19, 4)) as Clicks,
        cast(impressions as decimal(19, 4)) as Impressions
    from source 
        
)

select * from cleaned;
    ')

