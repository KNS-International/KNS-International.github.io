USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_deposco__PriceList__dbt_tmp" as with

source as (
    
        select * from "KNSDevSandbox"."Dev"."price_list"

),

cleaned as (

    select 
        cast(PRICE_LIST_ID as bigint) as PriceListId,
        cast(TRADING_PARTNER_ID as bigint) as TradingPartnerId
    from source

)

select * from cleaned;
    ')

