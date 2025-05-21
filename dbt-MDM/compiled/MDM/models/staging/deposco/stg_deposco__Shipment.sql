with

source as (
    
        select * from "KNSDataLake"."deposco"."shipment"

),

cleaned as (

    select 
        cast(SHIPMENT_ID as bigint) as ShipmentId,
        cast(SHIP_VIA as varchar(50)) as ShippingVia,
        cast(STATUS as varchar(50)) as Status
        -- cast(FREIGHT_TERMS_TYPE as varchar(50)) as FreightTermsType,
        -- cast(SHIPPING_COST as float) as ShippingCost
    from source

)

select * from cleaned