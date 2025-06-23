USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__LocationZones__dbt_tmp" as with

source as (
    
        select * from "KNSDataLake"."deposco"."location_zones"

),

cleaned as (

    select 
        cast(LOCATION_ID as bigint) as LocationId
    from source

)

select * from cleaned;
    ')

