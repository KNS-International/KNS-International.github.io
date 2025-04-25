
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_marts"."fct_marketing_ad__dbt_tmp__dbt_tmp_vw" as select * from "KNSDevDbt"."dbt_tlawson_intermediate"."int_sources_unioned";;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_tlawson_marts"."fct_marketing_ad__dbt_tmp" FROM "KNSDevDbt"."dbt_tlawson_marts"."fct_marketing_ad__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_tlawson_marts.fct_marketing_ad__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_tlawson_marts_fct_marketing_ad__dbt_tmp_cci'
        AND object_id=object_id('dbt_tlawson_marts_fct_marketing_ad__dbt_tmp')
    )
    DROP index "dbt_tlawson_marts"."fct_marketing_ad__dbt_tmp".dbt_tlawson_marts_fct_marketing_ad__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_tlawson_marts_fct_marketing_ad__dbt_tmp_cci
    ON "dbt_tlawson_marts"."fct_marketing_ad__dbt_tmp"

   


  