
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_marts"."FactCurrentStock__dbt_tmp__dbt_tmp_vw" as with

current_stock as (
    select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__CurrentStock"
)

select * from current_stock;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_prod_marts"."FactCurrentStock__dbt_tmp" FROM "KNSDevDbt"."dbt_prod_marts"."FactCurrentStock__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_prod_marts.FactCurrentStock__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_prod_marts_FactCurrentStock__dbt_tmp_cci'
        AND object_id=object_id('dbt_prod_marts_FactCurrentStock__dbt_tmp')
    )
    DROP index "dbt_prod_marts"."FactCurrentStock__dbt_tmp".dbt_prod_marts_FactCurrentStock__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_prod_marts_FactCurrentStock__dbt_tmp_cci
    ON "dbt_prod_marts"."FactCurrentStock__dbt_tmp"

   


  