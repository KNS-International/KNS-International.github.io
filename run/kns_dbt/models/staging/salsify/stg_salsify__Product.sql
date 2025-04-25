USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_staging"."stg_salsify__Product__dbt_tmp" as with

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
        cast([Sell Out Target Date Month] as nvarchar(128)) as SellOutTargetDateMonth,
        cast([Sell Out Target Date Year] as nvarchar(128)) as SellOutTargetDateYear,
        cast([Planned Arrival Date Month] as nvarchar(128)) as PlannedArrivalDateMonth,
        cast([First Sales Date] as nvarchar(128)) as FirstSalesDate,
        cast(Status as nvarchar(128)) as Status,
        cast([Closure Type] as nvarchar(128)) as ClosureType,
        cast([Style Type] as nvarchar(128)) as StyleType,
        cast(Style as nvarchar(128)) as Style,
        cast([Parent SKU] as nvarchar(128)) as ParentSku,
        cast([Calf Width] as nvarchar(128)) as CalfWidth,
        cast([Shoe Width] as nvarchar(128)) as ShoeWidth,
        cast([Anaplan Active] as bit) as AnaplanActive,
        cast([Case Quantity] as int) as CaseQuantity,
        cast(MSRP as decimal(19, 4)) as Msrp,
        cast(Division as nvarchar(32)) as Division,
        cast([Season Budget] as nvarchar(16)) as SeasonBudget,
        cast([Selling Status] as nvarchar(32)) as SellingStatus
    from source

)

select * from cleaned;
    ')

