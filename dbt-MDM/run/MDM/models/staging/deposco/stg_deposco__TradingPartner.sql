USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_deposco__TradingPartner__dbt_tmp" as with

source as (

    select * from "KNSDataLake"."deposco"."trading_partner"

),

cleaned as (

    select 
        cast([NAME] as nvarchar(50)) as Name,
        cast([BILL_TO_COUNTRY] as varchar(100)) as FulfillmentChannelType,
        cast([BILL_TO_STATE_PROVINCE] as varchar(100)) as FinancialChannelType
    from source

)

select * from cleaned;
    ')

