USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_products__Size__dbt_tmp" as select * from "KNSUnifiedMDM"."Products"."Size";
    ')

