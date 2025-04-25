
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_marts"."DimTradingPartner__dbt_tmp__dbt_tmp_vw" as with 

trading_partners as (

    select
        TRADING_PARTNER_ID as TradingPartnerId,
        NAME as Name,
        CODE as Code,
        BILL_TO_COUNTRY as ChannelType
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__TradingPartner"

),

final as (

    select
        *,
        iif (NAME in (''DSW'', ''MACYS'', ''KOHLS'', ''TARGET PLUS'', ''NORDSTROM RACK'', ''JCPENNEY'', ''AMAZON'', ''WALMART MARKETPLACE'', ''KOHLS - WS''), 1, 0) as IsTopPartner
    from trading_partners

)

select * from final;;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_tlawson_marts"."DimTradingPartner__dbt_tmp" FROM "KNSDevDbt"."dbt_tlawson_marts"."DimTradingPartner__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_tlawson_marts.DimTradingPartner__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_tlawson_marts_DimTradingPartner__dbt_tmp_cci'
        AND object_id=object_id('dbt_tlawson_marts_DimTradingPartner__dbt_tmp')
    )
    DROP index "dbt_tlawson_marts"."DimTradingPartner__dbt_tmp".dbt_tlawson_marts_DimTradingPartner__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_tlawson_marts_DimTradingPartner__dbt_tmp_cci
    ON "dbt_tlawson_marts"."DimTradingPartner__dbt_tmp"

   


  