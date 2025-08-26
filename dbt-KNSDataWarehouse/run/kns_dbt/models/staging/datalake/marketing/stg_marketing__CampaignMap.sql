USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_marketing__CampaignMap__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."marketing"."CampaignTradingPartnerMap"

),

cleaned as (

    select 
        cast(CampaignName as nvarchar(128)) as OldCampaignName,
        cast(NewCampaignName as nvarchar(128)) as NewCampaignName
    from source 
        
)

select * from cleaned;
    ')

