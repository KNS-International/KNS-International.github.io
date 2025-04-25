with 

source as (

    select * from "KNSDataLake"."marketing"."PromoteIQ"

),

cleaned as (

    select 
         cast(Date as date) as Date,
         cast([Campaign Name] as nvarchar(128)) as [Campaign Name],
         cast([Vendor Name] as nvarchar(128)) as [Vendor Name],
         cast([Promoted Product / Creative ID] as nvarchar(128)) as [Promoted Product / Creative ID],
         cast([Promoted SKU] as nvarchar(128)) as [Promoted SKU],
         cast([Avg Order Value] as decimal(19, 4)) as [Avg Order Value],
         cast([Avg Unit Sold Value] as decimal(19, 4)) as [Avg Unit Sold Value],
         cast(CPA as decimal(19, 4)) as CPA,
         cast(CPC as decimal(19, 4)) as CPC,
         cast(CPM as decimal(19, 4)) as CPM,
         cast(ROAS as decimal(19, 4)) as ROAS,
         cast(CTR as decimal(19, 4)) as CTR,
         cast(Clicks as decimal(19, 4)) as Clicks,
         cast(Impressions as decimal(19, 4)) as Impressions,
         cast([SKU Conversion Rate] as decimal(19, 4)) as [SKU Conversion Rate],
         cast([SKU Order Count] as decimal(19, 4)) as [SKU Order Count],
         cast([Total Sales] as decimal(19, 4)) as [Total Sales],
         cast([Units Sold] as decimal(19, 4)) as [Units Sold],
         cast([Online Sales] as decimal(19, 4)) as [Online Sales],
         cast([In-store Sales] as decimal(19, 4)) as [In-store Sales],
         cast(Spend as decimal(19, 4)) as Spend
    from source
    where 
    Date >= dateadd(year, -2, getdate())


)

select * from cleaned;