USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_staging"."stg_dbo__Calendar__dbt_tmp" as with

calendar as (

    select
        *
    from "KNSDataLake"."dbo"."calendar"
)

select * from calendar;;
    ')

