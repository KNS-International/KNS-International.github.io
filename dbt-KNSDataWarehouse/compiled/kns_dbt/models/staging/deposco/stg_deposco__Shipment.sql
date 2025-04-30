with

source as (
    
        select * from "KNSDataLake"."deposco"."shipment"

),

cleaned as (

    select 
        cast(SHIPMENT_ID as bigint) as ShipmentId,
        cast(FREIGHT_TERMS_TYPE as varchar(50)) as FreightTermsType,
        cast(SHIPPING_COST as float) as ShippingCost
    from source

)

select * from cleaned