USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_netsuite__CustomrecordCsegKnsProductcat__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."netsuite"."CUSTOMRECORD_CSEG_KNS_PRODUCTCAT"

),

cleaned as (

    select 
        cast(id as bigint) as Id,
        cast(name as nvarchar(100)) as Name
    from source 
        
)

select * from cleaned;
    ')

