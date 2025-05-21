with

source as (
    
    select * from "KNSDataLake"."deposco"."order_header"

),

cleaned as (

    select
        cast(CUSTOMER_ORDER_NUMBER as varchar(50)) as CustomerOrderNumber,
        cast(CONSIGNEE_PARTNER_ID as bigint) as TradingPartnerId,
        cast(KNS_MT_PLACED_DATE as datetime) as PlacedAt,
        cast(KNS_MT_PLANNED_RELEASE_DATE as	datetime) as ContractualShipAt,
        cast(KNS_MT_PLANNED_SHIP_DATE as datetime) as PlannedShipAt,
        cast(SHIPPING_STATUS as int) as ShippingStatus,
        cast(ORDER_HEADER_ID as bigint) as OrderHeaderId,
        cast(KNS_MT_ACTUAL_SHIP_DATE as	datetime) as ShippedAt,
        cast(ORDER_DISCOUNT_SUBTOTAL as float) as DiscountAmount
    from source
    where TYPE = 'Sales Order'

)

select * from cleaned