with

source as (
    
        select * from "KNSDataLake"."deposco"."location_zones"

),

cleaned as (

    select 
        cast(LOCATION_ID as bigint) as LocationId
    from source

)

select * from cleaned