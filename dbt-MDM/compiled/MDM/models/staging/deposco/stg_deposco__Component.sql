with

source as (

    select * from "KNSDataLake"."deposco"."component"

),

cleaned as (

    select 
        cast([ITEM_ID] as bigint) as ItemId,
        cast([COMPONENT_ID] as bigint) as ComponentId
    from source

)

select * from cleaned