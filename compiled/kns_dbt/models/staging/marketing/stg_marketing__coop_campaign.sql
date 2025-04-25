with 

source as (

    select * from "KNSDataLake"."marketing"."CoOpCampaign"

),

cleaned as (

    select 
         cast(FrontCode as nvarchar(50)) as FrontCode,
         cast(BackCode as nvarchar(50)) as BackCode,
         cast(Spend as decimal(19, 4)) as Spend,
         cast(StartAt as date) as StartAt,
         cast(EndAt as date) as EndAt
    from source

)

select * from cleaned;