
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__PriceListDetail__dbt_tmp__dbt_tmp_vw" as 


with

source as (
    
        select * from "KNSDataLake"."deposco"."price_list_detail"

),

cleaned as (

    select 
        cast(PRICE_LIST_DETAIL_ID as bigint) as PriceListDetailId,
        cast(PRICE_LIST_ID as bigint) as PriceListId,
        cast(ITEM_ID as bigint) as ItemId,
        cast(SALES_PRICE as float) as SalesPrice,
        cast(SALES_EFFECTIVE_START as datetime) as SalesEffectiveStart,
        cast(SALES_EFFECTIVE_END as datetime) as SalesEffectiveEnd
    from source

)

select * from cleaned;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_prod_staging"."stg_deposco__PriceListDetail__dbt_tmp" FROM "KNSDevDbt"."dbt_prod_staging"."stg_deposco__PriceListDetail__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_prod_staging.stg_deposco__PriceListDetail__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_prod_staging_stg_deposco__PriceListDetail__dbt_tmp_cci'
        AND object_id=object_id('dbt_prod_staging_stg_deposco__PriceListDetail__dbt_tmp')
    )
    DROP index "dbt_prod_staging"."stg_deposco__PriceListDetail__dbt_tmp".dbt_prod_staging_stg_deposco__PriceListDetail__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_prod_staging_stg_deposco__PriceListDetail__dbt_tmp_cci
    ON "dbt_prod_staging"."stg_deposco__PriceListDetail__dbt_tmp"

   


  