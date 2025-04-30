
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_marts"."DimTradingPartner__dbt_tmp__dbt_tmp_vw" as with 

trading_partners as (

    select
        TradingPartnerId,
        Name,
        Code,
        BillToCountry as ChannelType
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__TradingPartner"

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
            SELECT * INTO "KNSDevDbt"."dbt_prod_marts"."DimTradingPartner__dbt_tmp" FROM "KNSDevDbt"."dbt_prod_marts"."DimTradingPartner__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_prod_marts.DimTradingPartner__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_prod_marts_DimTradingPartner__dbt_tmp_cci'
        AND object_id=object_id('dbt_prod_marts_DimTradingPartner__dbt_tmp')
    )
    DROP index "dbt_prod_marts"."DimTradingPartner__dbt_tmp".dbt_prod_marts_DimTradingPartner__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_prod_marts_DimTradingPartner__dbt_tmp_cci
    ON "dbt_prod_marts"."DimTradingPartner__dbt_tmp"

   


  