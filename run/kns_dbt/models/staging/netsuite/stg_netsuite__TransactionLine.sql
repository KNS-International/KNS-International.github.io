USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_staging"."stg_netsuite__TransactionLine__dbt_tmp" as with

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
        cast(memo as nvarchar(4000)) as Memo
    from source

)

select * from cleaned;
    ')

