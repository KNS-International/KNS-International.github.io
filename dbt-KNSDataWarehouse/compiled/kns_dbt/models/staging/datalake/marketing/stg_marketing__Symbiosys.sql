with 

source as (

    select * from "KNSDataLake"."marketing"."Symbiosys"

),

cleaned as (

    select 
        cast(Day as date) as Date,
        cast(Campaign as nvarchar(256)) as Campaign,
        cast(Channel as nvarchar(50)) as Channel,
        cast(Spend as decimal(19, 4)) as Spend,
        cast([Units Sold] as decimal(19, 4)) as [Units Sold],
        cast(Sales as decimal(19, 4)) as Sales
    from source

)

select * from cleaned;