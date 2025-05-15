with

source as (

    select * from "KNSUnifiedMDM"."Products"."Subclass"

),

cleaned as (

    select 
        cast(SubclassId as int) as SubclassId,
        cast(Name as nvarchar(64)) as Name,
        cast(Class as nvarchar(64)) as Class
    from source

)

select * from cleaned