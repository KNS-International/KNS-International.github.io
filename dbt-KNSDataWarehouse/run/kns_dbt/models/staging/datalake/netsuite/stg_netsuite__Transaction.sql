USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_netsuite__Transaction__dbt_tmp" as with

source as (

    select * from "KNSDataLake"."netsuite"."transaction"

),

cleaned as (

    select
        cast(id as bigint) as Id,
        cast(custbody_kns_po as nvarchar(4000)) as Memo,
        cast(entity as bigint) as Entity,
        cast(trandate as date) as TranDate,
        cast(tranid as nvarchar(90)) as TranId,
        cast(otherrefnum as nvarchar(90)) as OtherRefNum
    from source

)

select * from cleaned;
    ')

