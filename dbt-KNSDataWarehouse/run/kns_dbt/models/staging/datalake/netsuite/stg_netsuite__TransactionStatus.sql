USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_netsuite__TransactionStatus__dbt_tmp" as with

source as (

    select * from "KNSDataLake"."netsuite"."transactionStatus"

),

cleaned as (

    select
        cast(name as nvarchar(128)) as Name,
        cast(id as nvarchar(1)) as Id,
        cast(trantype as nvarchar(32)) as TranType
    from source

)

select * from cleaned;
    ')

