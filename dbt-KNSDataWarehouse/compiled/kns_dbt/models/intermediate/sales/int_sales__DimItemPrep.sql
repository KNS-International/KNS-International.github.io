with historical as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_kns__HistoricalDimItem"
),

item as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Item"
),

item_cogs as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__KnsItemCogs"
),

variants as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_products__Variant"
),

styles as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_products__Style"
),

brands as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_products__Brand"
),

subclasses as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_products__Subclass"
),

catalog as (
    select * from "KNSDevDbt"."dbt_prod_staging"."stg_products__Catalog"
),

product as (
    select
        v.Number,
        v.Status,
        v.ShoeWidth,
        v.CalfWidth,
        v.Parent,
        v.ClosureType,
        v.HeelType,
        v.StyleType,
        v.SizeRun,
        v.ColorName as Color,
        v.ColorClass,
        v.IsAnaplanActive as Anaplan,
        month(v.SellOutTargetAt) as SellOutTargetDateMonth,
        year(v.SellOutTargetAt) as SellOutTargetDateYear,
        v.PlannedArrivalAt as PlannedArrivalDateMonth,
        v.FirstSalesDateAt as FirstSalesDate,
        v.MSRP,
        v.IsSupplies,
        v.IsIntangible,
        v.DirectSourcingModel,
        v.SellingStatus,
        v.DtcWebsiteColor,
        s.Name as Style,
        c.Name as Catalog,
        c.BrandId,
        v.Subclass,
        s.Class,
        s.Vendor,
        v.VendorSku,
        s.Gender,
        s.Season,
        s.CaseQuantity,
        s.SeasonBudget,
        null as Size,
        b.Name as Brand,
        b.Division
    from variants v
    left join styles s on v.StyleId = s.StyleId
    left join catalog c on s.CatalogId = c.CatalogId
    left join brands b on c.BrandId = b.BrandId
),

final as (

    select
        i.ItemId,
        p.[Number],
        h.Category,
        h.Subcategory,
        coalesce(nullif(p.Catalog, ''), '*No Catalog*') as Catalog,
        coalesce(nullif(p.Vendor, ''), '*No Vendor*') as Vendor,
        coalesce(nullif(p.Gender, ''), '*No Gender*') as Gender,
        case
            when i.[Number] in ('Order Protection', 'Navidium Shipping Protection') then 'Shipping Protection'
            else coalesce(nullif(p.Parent , ''), '*No Parent*')
        end as Parent,
        coalesce(nullif(p.Color, ''), '*No Color*') as Color,
        coalesce(nullif(p.Season, ''), '*No Season*') as Season,
        coalesce(nullif(p.Size, ''), '*No Size*') as Size,
        i.UpdatedDate as UpdatedAt,
        h.FirstReceivedDate,
        year(p.FirstSalesDate) as IntroductionYear,
        h.CloseOut,
        h.CloseOutDate,
        h.ToeStyle,
        p.ClosureType,
        h.HeelType,
        p.StyleType,
        p.SizeRun,
        h.LiquidationCloseOut,
        p.CaseQuantity,
        p.Anaplan,
        h.SoftCloseOut,
        ic.cost as Cost,
        p.Style,
        h.MasterCategory,
        p.Class,
        p.Subclass,
        p.VendorSKU,
        p.SellOutTargetDateMonth,
        p.SellOutTargetDateYear,
        p.PlannedArrivalDateMonth,
        p.FirstSalesDate,
        case 
            when p.Number is null and p.Status = 'Active' then 'Terminated'
            else p.Status
        end as Status,
        p.CalfWidth,
        '' as BrandFinancialEntity, -- WHY DO WE HAVE THIS?
        p.ShoeWidth,
        p.ColorClass,
        p.IsIntangible,
        p.MSRP,
        p.Division,
        p.IsSupplies,
        case
            when i.ItemId = 153085 then 1
            when i.ItemId = 170695 then 1
            when i.ItemId = 204260 then 1 
            when i.ItemId = 204262 then 2
            when i.ItemId = 204261 then 3
            when i.ItemId = 212170 then 4
            else coalesce(p.BrandId, 0)
        end as BrandId,
        p.SeasonBudget,
        p.SellingStatus,
        p.DirectSourcingModel,
        p.DtcWebsiteColor
    from product p 
    left join item i on p.Number = i.[Number]
    left join historical h on h.ItemId = i.ItemId
    left join item_cogs ic on ic.ItemId=i.ItemId
    where i.[Number] is not null
    and (i.ClassType not in ('Girls''', 'Boys''', 'Gloves', 'Inventory', '') or i.ClassType is null)

)

select * from final