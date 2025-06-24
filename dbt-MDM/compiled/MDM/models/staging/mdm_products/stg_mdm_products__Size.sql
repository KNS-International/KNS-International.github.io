with

source as (

    select * from "KNSUnifiedMDM"."Products"."Size"

),

cleaned as (

    select 
        cast(SizeId as int) as SizeId,
        cast(Name as nvarchar(10)) as Name
    from source

)

select * from cleaned