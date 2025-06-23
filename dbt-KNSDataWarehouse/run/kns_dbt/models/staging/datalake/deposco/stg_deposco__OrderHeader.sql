USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__OrderHeader__dbt_tmp" as with

source as (
    
    select * from "KNSDataLake"."deposco"."order_header"

),

cleaned as (

    select
        cast(ORDER_HEADER_ID as bigint) as OrderHeaderId,
        cast(CURRENT_STATUS as varchar(50)) as CurrentStatus,
        cast(TYPE as varchar(50)) as Type,
        cast(CREATED_DATE as date) as CreatedDate,
        cast(SHIPPING_STATUS as int) as ShippingStatus,
        cast(CONSIGNEE_PARTNER_ID as bigint) as ConsigneePartnerId,
        cast(SELLER as varchar(50)) as Seller,
        cast(PARENT_ORDER_ID as bigint) as ParentOrderId,
        cast(ORDER_SOURCE as varchar(100)) as OrderSource,
        cast(CUSTOMER_ORDER_NUMBER as varchar(50)) as CustomerOrderNumber,
        cast(UPDATED_DATE as datetime) as UpdatedDate,
        cast(KNS_MT_PLACED_DATE as datetime) as KnsMtPlacedDate,
        cast(KNS_MT_CREATED_DATE as datetime) as KnsMtCreatedDate,
        cast(KNS_MT_PLANNED_RELEASE_DATE as	datetime) as KnsMtPlannedReleaseDate,
        cast(KNS_MT_PLANNED_SHIP_DATE as datetime) as KnsMtPlannedShipDate,
        cast(KNS_MT_ACTUAL_SHIP_DATE as	datetime) as KnsMtActualShipDate,
        cast(KNS_MT_ACTUAL_RELEASE_DATE as datetime) as KnsMtActualReleaseDate,
        cast(CO_HEADER_ID as bigint) as CoHeaderId,
        cast(
        case 
            when CUSTOM_ATTRIBUTE1 = ''Express'' then 1 
            else 0
        end 
        as bit) as IsExpress
    from source

)

select * from cleaned;
    ')

