with 

source as (

    select * from "KNSDataLake"."netsuite"."CUSTOMRECORD_CSEG_KNS_PROD_SUBCL"

),

cleaned as (

    select 
        cast(id as bigint) as Id,
        cast(name as nvarchar(100)) as Name
    from source 
        
)

select * from cleaned