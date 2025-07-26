
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactPurchaseOrderLine__dbt_tmp__dbt_tmp_vw" as 
  


select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__PurchaseOrderLine";
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactPurchaseOrderLine__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactPurchaseOrderLine__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactPurchaseOrderLine__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactPurchaseOrderLine__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactPurchaseOrderLine__dbt_tmp')
    )
    DROP index "KNS"."FactPurchaseOrderLine__dbt_tmp".KNS_FactPurchaseOrderLine__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactPurchaseOrderLine__dbt_tmp_cci
    ON "KNS"."FactPurchaseOrderLine__dbt_tmp"

   


  