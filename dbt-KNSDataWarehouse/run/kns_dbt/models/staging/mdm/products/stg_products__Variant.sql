USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_products__Variant__dbt_tmp" as select * from "KNSUnifiedMDM"."Products"."Variant";
    ')

