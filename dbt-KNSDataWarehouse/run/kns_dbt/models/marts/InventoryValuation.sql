
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."InventoryValuation__dbt_tmp__dbt_tmp_vw" as 
  


with

final as (
    select 
        *
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__InventoryValuation"
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."InventoryValuation__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."InventoryValuation__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.InventoryValuation__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_InventoryValuation__dbt_tmp_cci'
        AND object_id=object_id('KNS_InventoryValuation__dbt_tmp')
    )
    DROP index "KNS"."InventoryValuation__dbt_tmp".KNS_InventoryValuation__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_InventoryValuation__dbt_tmp_cci
    ON "KNS"."InventoryValuation__dbt_tmp"

   


  