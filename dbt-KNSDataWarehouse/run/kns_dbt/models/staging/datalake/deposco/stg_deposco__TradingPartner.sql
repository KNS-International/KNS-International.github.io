USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__TradingPartner__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."deposco"."trading_partner"

),

cleaned as (

    select
         cast(TRADING_PARTNER_ID as bigint) as TradingPartnerId,
         cast(CODE as varchar(40)) as Code,
         cast(NAME as varchar(50)) as Name,
         cast(BILL_TO_COUNTRY as varchar(100)) as BillToCountry,
         cast(CONTACT_EMAIL as varchar(50)) as ContactEmail,
         cast(TAX_RATE as float) as TaxRate,
         cast(UPS_ACCOUNT_NUMBER as varchar(100)) as UpsAccountNumber
    from source

)

select * from cleaned;;
    ')

