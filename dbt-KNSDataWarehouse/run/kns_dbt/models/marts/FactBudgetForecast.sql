
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactBudgetForecast__dbt_tmp__dbt_tmp_vw" as 
  


with 

filters as (
    select
        Identifier,
        AccountNumber,
        AccountName,
        BrandId,
        Class,
        Subclass,
        TradingPartnerId,
        MonthEndDate,
        Amount
    from "KNSDevDbt"."dbt_prod_staging"."stg_orders__BudgetForecast"
    where AccountNumber in (''4000'', ''4050'', ''4100'', ''4101'', ''4102'', ''4103'', ''4104'', ''4105'', ''4106'')
),

final as (
    select * from filters
)

select * from final;
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

   


  