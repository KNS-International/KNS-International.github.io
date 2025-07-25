USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_kns__InventoryValuation__dbt_tmp" as with 

source as (
    
    select * from "KNSDataLake"."kns"."InventoryValuation"

),

cleaned as (

    select
        cast(Date as date) as Date,
        cast(ItemId as int) as ItemId,
        cast(ItemNumber as nvarchar(128)) as ItemNumber,
        cast(Valuation as decimal(19,4)) as Valuation,
        cast(Quantity as int) as Quantity
    from source
        
)

select * from cleaned;
    ')

