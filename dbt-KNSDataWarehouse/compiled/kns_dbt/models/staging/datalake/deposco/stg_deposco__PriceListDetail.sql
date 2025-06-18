


with

source as (
    
        select * from "KNSDataLake"."deposco"."price_list_detail"

),

cleaned as (

    select 
        cast(PRICE_LIST_DETAIL_ID as bigint) as PriceListDetailId,
        cast(PRICE_LIST_ID as bigint) as PriceListId,
        cast(ITEM_ID as bigint) as ItemId,
        cast(SALES_PRICE as float) as SalesPrice,
        cast(SALES_EFFECTIVE_START as datetime) as SalesEffectiveStart,
        cast(SALES_EFFECTIVE_END as datetime) as SalesEffectiveEnd
    from source

)

select * from cleaned