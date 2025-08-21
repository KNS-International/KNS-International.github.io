
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "Deposco"."DimTradingPartner__dbt_tmp__dbt_tmp_vw" as 
  


with 

trading_partners as (

    select
        TradingPartnerId,
        Name,
        Code,
        FinancialChannelType as ChannelType
    from "KNSDevDbt"."dbt_prod_staging"."stg_orders__TradingPartner"

),

final as (

    select
        *,
        iif (Name in (''DSW'', ''MACYS'', ''KOHLS'', ''TARGET PLUS'', ''NORDSTROM RACK'', ''JCPENNEY'', ''AMAZON'', ''WALMART MARKETPLACE'', ''KOHLS - WS''), 1, 0) as IsTopPartner
    from trading_partners

)

select * from final;;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."Deposco"."DimTradingPartner__dbt_tmp" FROM "KNSDataWarehouse"."Deposco"."DimTradingPartner__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS Deposco.DimTradingPartner__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'Deposco_DimTradingPartner__dbt_tmp_cci'
        AND object_id=object_id('Deposco_DimTradingPartner__dbt_tmp')
    )
    DROP index "Deposco"."DimTradingPartner__dbt_tmp".Deposco_DimTradingPartner__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX Deposco_DimTradingPartner__dbt_tmp_cci
    ON "Deposco"."DimTradingPartner__dbt_tmp"

   


  