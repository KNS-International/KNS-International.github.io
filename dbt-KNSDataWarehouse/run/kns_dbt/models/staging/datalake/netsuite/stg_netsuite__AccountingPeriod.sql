USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_netsuite__AccountingPeriod__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."netsuite"."AccountingPeriod"

),

cleaned as (

    select 
        cast(alllocked as nvarchar(1)) as AllLocked,
        cast(isposting as nvarchar(1)) as IsPosting,
        cast(enddate as date) as EndDate
    from source 
        
)

select * from cleaned;
    ')

