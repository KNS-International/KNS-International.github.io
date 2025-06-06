with

source as (

    select * from "KNSDataLake"."deposco"."trading_partner"

),

columns as (

    select 
        cast([TRADING_PARTNER_ID] as bigint) as TradingPartnerId,
        cast([NAME] as nvarchar(50)) as Name,
        cast([BILL_TO_COUNTRY] as varchar(100)) as FulfillmentChannelType,
        cast([BILL_TO_STATE_PROVINCE] as varchar(100)) as FinancialChannelType,
        cast([DROPSHIP_FEE] as float) as HandlingFee,
        cast([SIC] as varchar(20)) as HandlingFeeType,
        cast([UPS_ACCOUNT_NUMBER] as varchar(100)) as UpsAccountNumber,
        cast([FEDEX_ACCOUNT_NUMBER] as varchar(10)) as FedexAccountNumber,
        cast([CONTACT_EMAIL] as varchar(50)) as IsReturnsPartner,
        cast([CODE] as varchar(40)) as Code
    from source

),

cleaned as (
    select
        TradingPartnerId,
        Name,
        FulfillmentChannelType,
        FinancialChannelType,
        HandlingFee,
        case
            when HandlingFeeType = 'order' then 'Order'
            when HandlingFeeType is null and HandlingFee != 0 then 'Unit'
            else null
        end as HandlingFeeType,
        UpsAccountNumber,
        FedexAccountNumber,
        Code,
        IsReturnsPartner
    from columns
)

select * from cleaned