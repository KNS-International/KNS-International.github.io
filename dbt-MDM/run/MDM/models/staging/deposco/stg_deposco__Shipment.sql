USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_deposco__Shipment__dbt_tmp" as with

source as (
    
        select * from "KNSDataLake"."deposco"."shipment"

),

cleaned as (

    select 
        cast(SHIPMENT_ID as bigint) as ShipmentId,
        cast(SHIP_VIA as varchar(50)) as ShippingVia,
        cast(STATUS as varchar(50)) as Status,
        cast(FREIGHT_TERMS_TYPE as varchar(50)) as FreightTermsType,
        cast(SHIPPING_COST as float) as ShippingCost,
        cast(FREIGHT_BILL_TO_ACCOUNT as varchar(50)) as FreightBillToAccount,
        cast(TRACKING_NUMBER as varchar(100)) as TrackingNumber
    from source

)

select * from cleaned;
    ')

