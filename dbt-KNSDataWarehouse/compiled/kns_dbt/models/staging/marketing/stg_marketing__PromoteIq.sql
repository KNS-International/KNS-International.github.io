with 

source as (

    select * from "KNSDataLake"."marketing"."PromoteIQ"

),

cleaned as (

    select 
        cast(Date as date) as Date,
        cast([Campaign Name] as nvarchar(128)) as [Campaign Name],
        cast([Vendor Name] as nvarchar(128)) as [Vendor Name],
        cast(CTR as decimal(19, 4)) as CTR,
        cast(Impressions as decimal(19, 4)) as Impressions,
        cast([Total Sales] as decimal(19, 4)) as [Total Sales],
        cast([Units Sold] as decimal(19, 4)) as [Units Sold],
        cast(Spend as decimal(19, 4)) as Spend
    from source
    where 
    Date >= dateadd(year, -2, getdate())


)

select * from cleaned;