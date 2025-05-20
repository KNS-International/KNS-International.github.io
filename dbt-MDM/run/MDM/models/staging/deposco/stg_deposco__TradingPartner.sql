USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_deposco__TradingPartner__dbt_tmp" as with

source as (

    select * from "KNSDataLake"."deposco"."trading_partner"

),

columns as (

    select 
        cast([NAME] as nvarchar(50)) as Name,
        cast([BILL_TO_COUNTRY] as varchar(100)) as FulfillmentChannelType,
        cast([BILL_TO_STATE_PROVINCE] as varchar(100)) as FinancialChannelType,
        cast([DROPSHIP_FEE] as float) as HandlingFee,
        cast([SIC] as varchar(20)) as HandlingFeeType
    from source

),

cleaned as (
    select
        Name,
        FulfillmentChannelType,
        FinancialChannelType,
        HandlingFee,
        case
            when HandlingFeeType = ''order'' then ''Order''
            when HandlingFeeType is null and HandlingFee != 0 then ''Unit''
            else null
        end as HandlingFeeType
    from columns
)

select * from cleaned;
    ')

