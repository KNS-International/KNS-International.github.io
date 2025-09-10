with 

source as (
    
    select * from "KNSDataLake"."kns"."GoogleAnalyticsData"

),

cleaned as (

    select
        cast(Site as nvarchar(50)) as Site,
        cast(date as date) as Date,
        cast(sessionDefaultChannelGroup as nvarchar(50)) as SessionDefaultChannelGroup,
        cast(countryId as nvarchar(10)) as CountryId,
        cast(deviceCategory as nvarchar(50)) as DeviceCategory,
        cast(sessionSource as nvarchar(50)) as SessionSource,
        cast(sessions as decimal(19,4)) as Sessions
    from source
        
)

select * from cleaned