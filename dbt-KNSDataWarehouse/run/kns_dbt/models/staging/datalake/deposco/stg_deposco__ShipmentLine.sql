USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__ShipmentLine__dbt_tmp" as with

source as (
    
        select * from "KNSDataLake"."deposco"."shipment_line"

),

cleaned as (

    select 
        cast(SHIPMENT_ID as bigint) as ShipmentId,
        cast(SHIPPED_PACK_QUANTITY as float) as ShippedPackQuantity
    from source

)

select * from cleaned;
    ')

