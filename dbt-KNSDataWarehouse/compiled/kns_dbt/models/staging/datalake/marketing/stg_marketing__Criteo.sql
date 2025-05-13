with 

source as (

    select * from "KNSDataLake"."marketing"."Criteo"

),

cleaned as (

    select 
        cast(date as date) as date,
        cast(campaignName as nvarchar(128)) as campaignName,
        cast(retailerName as nvarchar(128)) as retailerName,
        cast(spend as decimal(19, 4)) as spend,
        cast(attributedSales as decimal(19, 4)) as attributedSales,
        cast(attributedUnits as decimal(19, 4)) as attributedUnits,
        cast(ctr as decimal(19, 4)) as ctr,
        cast(impressions as decimal(19, 4)) as impressions
    from source 
    where 
    date >= dateadd(year, -2, getdate())

        
)

select * from cleaned