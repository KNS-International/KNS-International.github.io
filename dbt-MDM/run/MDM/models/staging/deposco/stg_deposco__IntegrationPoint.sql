USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_deposco__IntegrationPoint__dbt_tmp" as with

source as (
    
        select * from "KNSDataLake"."deposco"."integration_point"

),

cleaned as (

    select 
        cast(PROPERTIES as varchar(max)) as Properties,
        cast(TRADING_PARTNER_ID as bigint) as TradingPartnerId,
        cast(TYPE as varchar(200)) as Type,
        cast(IS_ENABLED as bit) as IsEnabled
    from source

)

select * from cleaned;
    ')

