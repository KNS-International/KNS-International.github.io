
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactFreightContainerLine__dbt_tmp__dbt_tmp_vw" as 
  


select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FreightContainerLine";
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactFreightContainerLine__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactFreightContainerLine__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactFreightContainerLine__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactFreightContainerLine__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactFreightContainerLine__dbt_tmp')
    )
    DROP index "KNS"."FactFreightContainerLine__dbt_tmp".KNS_FactFreightContainerLine__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactFreightContainerLine__dbt_tmp_cci
    ON "KNS"."FactFreightContainerLine__dbt_tmp"

   


  