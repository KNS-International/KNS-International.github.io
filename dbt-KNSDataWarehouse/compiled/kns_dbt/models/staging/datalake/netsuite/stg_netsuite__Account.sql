with 

source as (

    select * from "KNSDataLake"."netsuite"."Account"

),

cleaned as (

    select 
        cast(id as bigint) as Id,
        cast(acctnumber as nvarchar(120)) as AcctNumber
    from source 
        
)

select * from cleaned