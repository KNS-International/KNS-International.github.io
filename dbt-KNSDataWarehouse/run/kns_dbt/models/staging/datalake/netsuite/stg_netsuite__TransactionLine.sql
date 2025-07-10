USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_netsuite__TransactionLine__dbt_tmp" as with

source as (

    select * from "KNSDataLake"."netsuite"."transactionLine"

),

cleaned as (

    select
        cast(uniquekey as bigint) as UniqueKey,
        cast([transaction] as bigint) as [Transaction],
        cast(rate as float) as Rate,
        cast(expenseaccount as bigint) as ExpenseAccount,
        cast(debitforeignamount as float) as DebitForeignAmount,
        cast(creditforeignamount as float) as CreditForeignAmount,
        cast(memo as nvarchar(4000)) as Memo,
        cast(entity as bigint) as Entity,
        cast(cseg_kns_brand_2024 as bigint) as CsegKnsBrand2024,
        cast(cseg_kns_productcat as bigint) as CsegKnsProductCat,
        cast(cseg_kns_prod_subcl as bigint) as CsegKnsProdSubcl,
        cast(quantity as float) as Quantity,
        cast(item as bigint) as Item,
        cast(netamount as float) as NetAmount
    from source

)

select * from cleaned;
    ')

