with 

source as (

    select * from "KNSDataLake"."netsuite"."item"

),

cleaned as (

    select 
        cast(id as bigint) as Id,
        cast(externalid as nvarchar(255)) as ExternalId
    from source 
        
)

select * from cleaned