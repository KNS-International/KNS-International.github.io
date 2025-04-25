with

source as (
    
        select * from "KNSDataLake"."deposco"."item"

),

cleaned as (

    select 
        cast(ITEM_ID as bigint) as ItemId,
        cast(INTANGIBLE_ITEM_FLAG as bit) as IntangibleItemFlag,
        cast(CLASS_TYPE as nvarchar(30)) as ClassType,
        cast(STYLE_NUMBER as varchar(100)) as StyleNumber,
        cast(COLOR_NAME as varchar(150)) as ColorName,
        cast(NAME as varchar(250)) as Name,
        cast([NUMBER] as varchar(200)) as [Number],
        cast(UPDATED_DATE as datetime) as UpdatedDate
    from source

)

select * from cleaned