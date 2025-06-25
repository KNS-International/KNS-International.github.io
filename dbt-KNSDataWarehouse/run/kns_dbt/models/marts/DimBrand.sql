
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."DimBrand__dbt_tmp__dbt_tmp_vw" as 
  


with

brands as (
    select
        BrandId,
        Name as Brand,
        case
            when Name = ''Discontinued'' then 4 
            when Name = ''Journee'' then 0 
            when Name = ''Vance'' then 2 
            when Name = ''Taft'' then 1 
            when Name = ''Birdies'' then 3 
        end as OrderIndex
    from "KNSDevDbt"."dbt_prod_staging"."stg_products__Brand"
)

select * from brands;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."DimBrand__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."DimBrand__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.DimBrand__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_DimBrand__dbt_tmp_cci'
        AND object_id=object_id('KNS_DimBrand__dbt_tmp')
    )
    DROP index "KNS"."DimBrand__dbt_tmp".KNS_DimBrand__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_DimBrand__dbt_tmp_cci
    ON "KNS"."DimBrand__dbt_tmp"

   


  