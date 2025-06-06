with

source as (

    select * from "KNSDataLake"."deposco"."item"

),

cleaned as (

    select 
        cast([NUMBER] as nvarchar(200)) as Number,
        cast([ITEM_ID] as bigint) as ItemId,
        cast([INTANGIBLE_ITEM_FLAG] as bit) as IsIntangible,
        cast([CLASS_TYPE] as varchar(30)) as IsSupplies,
        cast([COMPANY_ID] as int) as CompanyId
    from source

)

select * from cleaned