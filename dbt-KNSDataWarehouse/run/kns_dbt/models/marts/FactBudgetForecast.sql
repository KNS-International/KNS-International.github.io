
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactBudgetForecast__dbt_tmp__dbt_tmp_vw" as 
  


select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__BudgetForecast";
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactBudgetForecast__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactBudgetForecast__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactBudgetForecast__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactBudgetForecast__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactBudgetForecast__dbt_tmp')
    )
    DROP index "KNS"."FactBudgetForecast__dbt_tmp".KNS_FactBudgetForecast__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactBudgetForecast__dbt_tmp_cci
    ON "KNS"."FactBudgetForecast__dbt_tmp"

   


  