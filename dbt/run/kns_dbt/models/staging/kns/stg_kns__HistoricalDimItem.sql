USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_kns__HistoricalDimItem__dbt_tmp" as with 

source as (
    
    select * from "KNSDevSandbox"."Dev"."HistoricalDimItem"

),

cleaned as (

    select
        cast(ItemId as int) as ItemId,
        cast(Category as nvarchar(200)) as Category,
        cast(Subcategory as nvarchar(200)) as Subcategory,
        cast(FirstReceivedDate as date) as FirstReceivedDate,
        cast(CloseOut as nvarchar(8)) as CloseOut,
        cast(CloseOutDate as date) as CloseOutDate,
        cast(ToeStyle as nvarchar(50)) as ToeStyle,
        cast(HeelType as nvarchar(50)) as HeelType,
        cast(LiquidationCloseOut as bit) as LiquidationCloseOut,
        cast(SoftCloseOut as bit) as SoftCloseOut,
        cast(MasterCategory as nvarchar(200)) as MasterCategory
    from source
        
)

select * from cleaned;
    ')

