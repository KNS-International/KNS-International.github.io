USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_netsuite__Entity__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."netsuite"."entity"

),

cleaned as (

    select 
        cast(id as bigint) as Id,
        cast(entityid as nvarchar(128)) as EntityId
    from source 
        
)

select * from cleaned;
    ')

