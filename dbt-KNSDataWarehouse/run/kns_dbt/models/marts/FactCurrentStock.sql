
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactCurrentStock__dbt_tmp__dbt_tmp_vw" as 
  


with

current_stock as (
    select cs.* 
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__CurrentStock" cs
    join "KNSDataWarehouse"."Deposco"."DimItem" i on cs.ItemId = i.ItemId
)

select * from current_stock;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactCurrentStock__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactCurrentStock__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactCurrentStock__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactCurrentStock__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactCurrentStock__dbt_tmp')
    )
    DROP index "KNS"."FactCurrentStock__dbt_tmp".KNS_FactCurrentStock__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactCurrentStock__dbt_tmp_cci
    ON "KNS"."FactCurrentStock__dbt_tmp"

   


  