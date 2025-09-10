with 

source as (

    select * from "KNSDataLake"."marketing"."Epsilon_Agg"

),

cleaned as (

    select 
        cast(campaign_id as nvarchar(255)) as CampaignId,
        cast(campaign_name as nvarchar(255)) as CampaignName
    from source 
        
)

select * from cleaned