with 

brand as (
    select * from "KNSDevDbt"."tlawson"."seed_Brands"
),

historical as (
    select * from "KNSDevDbt"."dbt_tlawson_staging"."stg_kns__HistoricalDimItem"
),

item as (
    select * from "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__Item"
),

item_cogs as (
    select * from "KNSDevDbt"."dbt_tlawson_staging"."stg_netsuite__KnsItemCogs"
),

product as (

    select * from "KNSDevDbt"."dbt_tlawson_staging"."stg_salsify__Product"

),

final as (

    select
        i.ItemId,
        i.[Number],
        h.Category,
        h.Subcategory,
        coalesce(nullif(p.Brand, ''), '*No Vendor*') as Catalog,
        coalesce(nullif(p.Vendor, ''), '*No Vendor*') as Vendor,
        coalesce(nullif(p.Gender, ''), '*No Gender*') as Gender,
        case
            when i.[Number] in ('Order Protection', 'Navidium Shipping Protection') then 'Shipping Protection'
            else coalesce(nullif(p.ParentSku , ''), '*No Parent*')
        end as Parent,
        coalesce(nullif(p.Color, ''), '*No Color*') as Color,
        coalesce(nullif(p.Seasonality, ''), '*No Season*') as Season,
        coalesce(nullif(p.Size, ''), '*No Size*') as Size,
        i.UpdatedDate as UpdatedAt,
        h.FirstReceivedDate,
        try_convert(int, nullif(year(try_convert(date, p.FirstSalesDate)), '')) as IntroductionYear,
        h.CloseOut,
        h.CloseOutDate,
        h.ToeStyle,
        p.ClosureType,
        h.HeelType,
        p.StyleType,
        p.SizeRun,
        h.LiquidationCloseOut,
        p.CaseQuantity,
        p.AnaplanActive as Anaplan,
        h.SoftCloseOut,
        p.Style,
        h.MasterCategory,
        p.SubCategory as Class,
        p.MerchandiseSubclass as Subclass,
        p.VendorSku as VendorSKU,
        charindex(left(nullif(p.SellOutTargetDateMonth, ''), 3),'JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC')/4+1 as SellOutTargetDateMonth,
        nullif(trim(p.SellOutTargetDateYear), '') as SellOutTargetDateYear,
        charindex(left(nullif(p.PlannedArrivalDateMonth, ''), 3),'JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC')/4+1 as PlannedArrivalDateMonth,
        nullif(try_convert(date, p.FirstSalesDate), convert(date, '1900-01-01')) as FirstSalesDate,
        case 
            when p.MainSku is null and p.Status = 'Active' then 'Terminated'
            else p.Status
        end as Status,
        p.CalfWidth,
        '' as BrandFinancialEntity,
        p.ShoeWidth,
        p.ColorClass,
        i.IntangibleItemFlag as IsIntangible,
        p.MSRP,
        p.Division,
        iif(i.ClassType like '%suppl%', 1, 0) as IsSupplies,
        coalesce(b.BrandId, 0) as BrandId,
        p.SeasonBudget,
        p.SellingStatus
    from item i
    left join product p on p.MainSku = i.[Number]
    left join brand b on b.Brand = case
        when p.Brand in ('Journee Collection', 'Journee Signature') then 'Journee'
        when p.Brand in ('Territory', 'Thomas & Vine', 'Taft 365') then 'Discontinued'
        else p.Brand
    end
    left join historical h on h.ItemId = i.ItemId
    left join item_cogs ic on ic.ItemId=i.ItemId
    where i.[Number] is not null
    and (i.ClassType not in ('Girls''', 'Boys''', 'Gloves', 'Inventory', '') or i.ClassType is null)

)

select * from final