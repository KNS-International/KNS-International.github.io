USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_staging"."stg_deposco__CoLine__dbt_tmp" as with 

source as (
    
    select * from "KNSDataLake"."deposco"."co_line"

),

cleaned as (

    select
        cast(CO_LINE_ID as bigint) as CoLineId,
        cast(UPDATED_DATE as datetime) as UpdatedDate,
        cast(STATUS as varchar(50)) as Status
    from source

)

select * from cleaned;
    ')

