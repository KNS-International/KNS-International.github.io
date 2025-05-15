USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_mdm_products__Catalog__dbt_tmp" as with

source as (

    select * from "KNSUnifiedMDM"."Products"."Catalog"

),

cleaned as (

    select 
        cast(CatalogId as int) as CatalogId,
        cast(Name as nvarchar(32)) as Name,
        cast(BrandId as int) as BrandId
    from source

)

select * from cleaned;
    ')

