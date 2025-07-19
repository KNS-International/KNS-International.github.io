USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_netsuite__InboundShipmentItem__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."netsuite"."InboundShipmentItem"

),

cleaned as (

    select 
        cast(id as bigint) as Id,
        cast(inboundshipment as bigint) as InboundShipmentId,
        cast(purchaseordertransaction as bigint) as PurchaseOrderTransactionId,
        cast(shipmentitemtransaction as bigint) as ShipmentItemTransactionId,
        cast(quantityexpected as float) as QuantityExpected,
        cast(quantityreceived as float) as QuantityReceived,
        cast(quantityremaining as float) as QuantityRemaining
    from source 
        
)

select * from cleaned;
    ')

