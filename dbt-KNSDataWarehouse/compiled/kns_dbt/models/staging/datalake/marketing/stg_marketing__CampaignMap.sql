with 

source as (

    select * from "KNSDataLake"."marketing"."CampaignTradingPartnerMap"

),

cleaned as (

    select 
        cast(CampaignName as nvarchar(128)) as OldCampaignName,
        cast(NewCampaignName as nvarchar(128)) as NewCampaignName
    from source 
        
)

select * from cleaned