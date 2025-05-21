USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_deposco__ShipmentOrderHeader__dbt_tmp" as with

source as (
    
        select * from "KNSDataLake"."deposco"."shipment_order_header"

),

cleaned as (

    select 
        cast(ORDER_HEADER_ID as bigint) as OrderHeaderId,
        cast(SHIPMENT_ID as bigint) as ShipmentId
    from source

)

select * from cleaned;
    ')

