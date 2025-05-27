USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_netsuite__Transaction__dbt_tmp" as with

source as (

    select * from "KNSDataLake"."netsuite"."transaction"

),

cleaned as (

    select
        cast(tranid as nvarchar(90)) as TranId,
        cast(custbody_kns_po as nvarchar(4000)) as CustBodyKnsPo,
        cast(otherrefnum as nvarchar(90)) as OtherRefNum,
        cast(entity as bigint) as Entity,
        cast(id as bigint) as Id,
        cast(trandate as date) as TranDate
    from source

)

select * from cleaned;
    ')

