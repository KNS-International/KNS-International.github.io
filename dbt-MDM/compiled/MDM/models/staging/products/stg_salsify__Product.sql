with

source as (

    select * from "KNSDataLake"."salsify"."Product"

),

cleaned as (

    select 
        cast([Main SKU] as nvarchar(128)) as MainSku,
        cast([Sub Category] as nvarchar(128)) as SubCategory,
        cast([Merchandise Subclass] as nvarchar(128)) as MerchandiseSubclass,
        cast([Color Class] as nvarchar(128)) as ColorClass,
        cast(Color as nvarchar(128)) as Color,
        cast(Brand as nvarchar(128)) as Brand,
        cast(Gender as nvarchar(128)) as Gender,
        cast(Size as nvarchar(128)) as Size,
        cast(Seasonality as nvarchar(128)) as Seasonality,
        cast([Size Run] as nvarchar(128)) as SizeRun,
        cast(Vendor as nvarchar(128)) as Vendor,
        cast([Vendor SKU] as nvarchar(128)) as VendorSku,
        cast(case lower([Sell Out Target Date Month])
            when 'january' then 1
            when 'february' then 2
            when 'march' then 3
            when 'april' then 4
            when 'may' then 5
            when 'june' then 6
            when 'july' then 7
            when 'august' then 8
            when 'september' then 9
            when 'october' then 10
            when 'november' then 11
            when 'december' then 12
            else null
        end as int) as SellOutTargetDateMonth,
        nullif(cast([Sell Out Target Date Year] as int), 0) as SellOutTargetDateYear,
        cast([Planned Arrival Date Month] as nvarchar(128)) as PlannedArrivalDateMonth,
        nullif(cast([First Sales Date] as date), '1900-01-01') as FirstSalesDateAt,
        cast(Status as nvarchar(128)) as Status,
        cast([Closure Type] as nvarchar(128)) as ClosureType,
        cast([Heel Height] as nvarchar(128)) as HeelHeight,
        cast([Style Type] as nvarchar(128)) as StyleType,
        cast(Style as nvarchar(128)) as Style,
        cast([Parent SKU] as nvarchar(128)) as ParentSku,
        cast([Calf Width] as nvarchar(128)) as CalfWidth,
        cast([Shoe Width] as nvarchar(128)) as ShoeWidth,
        cast([Anaplan Active] as bit) as AnaplanActive,
        cast([Case Quantity] as int) as CaseQuantity,
        cast(MSRP as decimal(19, 4)) as Msrp,
        cast([Season Budget] as nvarchar(16)) as SeasonBudget,
        cast([Selling Status] as nvarchar(32)) as SellingStatus,
        cast([Direct Sourcing Model] as nvarchar(64)) as DirectSourcingModel,
        cast([DTC Website Color] as nvarchar(64)) as DtcWebsiteColor
    from source
    -- where nullif(trim([Parent SKU]), '') is not null

)

select * from cleaned