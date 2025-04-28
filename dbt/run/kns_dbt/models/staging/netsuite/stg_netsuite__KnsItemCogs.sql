USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_netsuite__KnsItemCogs__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."netsuite"."KNS_ItemCogs"

),

cleaned as (

    select 
        cast(ItemId as bigint) as ItemId,
        cast(Cost as decimal(19,4)) as Cost
    from source 
        
)

select * from cleaned;
    ')

