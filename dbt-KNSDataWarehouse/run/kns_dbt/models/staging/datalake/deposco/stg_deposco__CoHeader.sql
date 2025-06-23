USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__CoHeader__dbt_tmp" as with 

source as (
    
    select * from "KNSDataLake"."deposco"."co_header"

),

cleaned as (

    select
        cast(CO_HEADER_ID as bigint) as CoHeaderId,
        cast(STATUS as varchar(50)) as Status
    from source

)

select * from cleaned;
    ')

