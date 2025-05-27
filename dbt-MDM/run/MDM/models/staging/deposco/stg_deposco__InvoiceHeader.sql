USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."stg_deposco__InvoiceHeader__dbt_tmp" as with

source as (

    select * from "KNSDataLake"."deposco"."invoice_header"

),

cleaned as (

    select 
        cast([INVOICE_HEADER_ID] as bigint) as InvoiceHeaderId,
        cast([ORDER_HEADER_ID] as bigint) as OrderHeaderId,
        cast(NUMBER as varchar(75)) as Number
    from source

)

select * from cleaned;
    ')

