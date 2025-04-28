USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__StockUnit__dbt_tmp" as with 

source as (
    
    select * from "KNSDataLake"."deposco"."stock_unit"

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

