with 

source as (

    select * from "KNSDataLake"."netsuite"."AccountingPeriod"

),

cleaned as (

    select 
        cast(alllocked as nvarchar(1)) as AllLocked,
        cast(isposting as nvarchar(1)) as IsPosting,
        cast(enddate as date) as EndDate
    from source 
        
)

select * from cleaned