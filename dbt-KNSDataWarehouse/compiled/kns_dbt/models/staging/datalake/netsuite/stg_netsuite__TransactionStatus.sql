with

source as (

    select * from "KNSDataLake"."netsuite"."transactionStatus"

),

cleaned as (

    select
        cast(name as nvarchar(128)) as Name,
        cast(id as nvarchar(1)) as Id,
        cast(trantype as nvarchar(32)) as TranType
    from source

)

select * from cleaned