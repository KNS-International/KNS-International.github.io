with

source as (
    
        select * from "KNSDataLake"."deposco"."shipment_line"

),

cleaned as (

    select 
        cast(SHIPMENT_ID as bigint) as ShipmentId,
        cast(SHIPPED_PACKED_QUANTITY as float) as ShippedPackedQuantity
    from source

)

select * from cleaned