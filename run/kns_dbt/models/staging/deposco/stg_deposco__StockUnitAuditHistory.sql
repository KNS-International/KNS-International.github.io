USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_staging"."stg_deposco__StockUnitAuditHistory__dbt_tmp" as with 

source as (
    
    select * from "KNSDataLake"."deposco"."STOCK_UNIT_AUDIT_HISTORY"

),

cleaned as (

    select
        cast(ITEM_ID as bigint) as ItemId,
        cast(PACK_ID as bigint) as PackId,
        cast(QUANTITY as int) as Quantity,
        cast(PeriodStart as date) as PeriodStart,
        cast(PeriodEnd as date) as PeriodEnd,
        cast(LOCATION_ID as bigint) as LocationId
    from source

)

select * from cleaned;
    ')

