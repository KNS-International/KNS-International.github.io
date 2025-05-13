USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__Shipment__dbt_tmp" as with

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

select * from cleaned;
    ')

