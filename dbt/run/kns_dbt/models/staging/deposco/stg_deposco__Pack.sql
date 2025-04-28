USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__Pack__dbt_tmp" as with

source as (
    
        select * from "KNSDataLake"."deposco"."pack"

),

cleaned as (

    select 
        cast(PACK_ID as bigint) as PackId,
        cast(QUANTITY as int) as Quantity
    from source

)

select * from cleaned;
    ')

