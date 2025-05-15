with

source as (

    select * from "KNSDataLake"."deposco"."item"

),

cleaned as (

    select 
        cast([NUMBER] as nvarchar(200)) as Number,
        cast([INTANGIBLE_ITEM_FLAG] as bit) as IsIntangible,
        cast([CLASS_TYPE] as varchar(30)) as IsSupplies
    from source

)

select * from cleaned