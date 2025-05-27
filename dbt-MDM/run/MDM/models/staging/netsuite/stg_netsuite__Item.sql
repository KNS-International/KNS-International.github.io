USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_netsuite__Item__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."netsuite"."item"

),

cleaned as (

    select 
        cast(id as bigint) as Id,
        cast(externalid as nvarchar(255)) as ExternalId
    from source 
        
)

select * from cleaned;
    ')

