with

source as (
    
    select * from "KNSDataLake"."deposco"."order_line"

),

cleaned as (

    select
        cast(ORDER_LINE_ID as bigint) as OrderLineId,
        cast(PACK_ID as bigint) as PackId,
        cast(ORDER_HEADER_ID as bigint) as OrderHeaderId,
        cast(ITEM_ID as bigint) as ItemId,
        cast(ORDER_PACK_QUANTITY as float) as OrderPackQuantity,
        cast(CANCELED_PACK_QUANTITY as float) as CanceledPackQuantity,
        cast(ORDER_LINE_STATUS as varchar(50)) as OrderLineStatus,
        -- cast(CO_LINE_ID as bigint) as CoLineId,
        -- cast(SHIPPED_PACK_QUANTITY as float) as ShippedPackQuantity,
        cast(UNIT_COST as float) as UnitCost
        -- cast(UPDATED_DATE as datetime) as UpdatedDate
    from source
    where CREATED_DATE < dateadd(minute, -30, getdate())
    and ORDER_PACK_QUANTITY >= 0


)

select * from cleaned