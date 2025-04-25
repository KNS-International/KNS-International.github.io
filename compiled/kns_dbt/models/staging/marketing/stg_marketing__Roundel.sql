with 

source as (

    select * from "KNSDataLake"."marketing"."Roundel"

),

cleaned as (

    select 
        cast([Event Date] as date) as date,
        cast([Campaign Name] as nvarchar(128)) as campaignName,
        cast(left(brand, 1) as nvarchar(1)) as brand,
        cast([platform name] as nvarchar(128)) as platform,
        cast([Adjusted Actualized Spend] as decimal(19, 4)) as spend,
        cast([Attributed Total Sales] as decimal(19, 4)) as attributedSales,
        cast([Attributed Total Units] as decimal(19, 4)) as attributedUnits,
        cast(Clicks as decimal(19, 4)) as clicks,
        cast(impressions as decimal(19, 4)) as impressions
    from source 
    where 
    [Event Date] >= dateadd(year, -2, getdate())

        
)

select * from cleaned