USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_orders__SalesOrder__dbt_tmp" as select * from "KNSUnifiedMDM"."Orders"."SalesOrder";
    ')

