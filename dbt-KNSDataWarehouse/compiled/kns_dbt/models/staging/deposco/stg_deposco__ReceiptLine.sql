with

source as (
    
        select * from "KNSDataLake"."deposco"."receipt_line"

),

cleaned as (

    select 
        cast(ORDER_LINE_ID as bigint) as OrderLineId,
        cast(RECEIVED_PACK_QUANTITY as int) as ReceivedPackQuantity
    from source

)

select * from cleaned