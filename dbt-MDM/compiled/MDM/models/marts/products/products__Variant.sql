



with styles as ( 
    select * from "KNSUnifiedMDM"."Products"."Style"
),

supplies as (
    select 
        Number, 
        null as Code, 
        2590 as StyleId, 
        null as SizeId, 
        null as Status, 
        null as SellingStatus,
        null as ShoeWidth, 
        null as CalfWidth, 
        null as Parent, 
        null as ClosureType, 
        null as HeelType, 
        null as StyleType,
        null as SizeRun, 
        null as ColorName, 
        null as ColorClass, 
        null as Subclass, 
        null as VendorSku, 
        null as IsAnaplanActive,
        null as SellOutTargetAt, 
        null as PlannedArrivalAt, 
        null as FirstSalesDateAt, 
        null as MSRP, 
        1 as IsSupplies, 
        0 as IsIntangible, 
        null as DirectSourcingModel
    from "KNSUnifiedMDM"."prod"."stg_deposco__Item" i
    where IsSupplies like '%suppl%'
        and CompanyId = 73
),

sizes as (
    select * from "KNSUnifiedMDM"."prod"."int_products__Size"
),

variants as (
    select 
        p.MainSku as Number,
        null as Code,
        s.StyleId,
        sz.SizeId,
        p.Status,
        p.SellingStatus,
        p.ShoeWidth,
        p.CalfWidth,
        p.ParentSku as Parent,
        p.ClosureType,
        p.HeelHeight as HeelType,
        p.StyleType,
        p.SizeRun,
        nullif(p.DtcWebsiteColor, '') as ColorName,
        p.ColorClass,
        p.MerchandiseSubclass as Subclass,
        p.VendorSku,
        p.AnaplanActive as IsAnaplanActive,
        case 
            when p.SellOutTargetDateYear is not null and p.SellOutTargetDateMonth is not null
            then datefromparts(p.SellOutTargetDateYear, p.SellOutTargetDateMonth, 1)
            else null
        end as SellOutTargetAt,
        p.PlannedArrivalDateMonth as PlannedArrivalAt,
        p.FirstSalesDateAt,
        p.MSRP,
        0 as IsSupplies,
        i.IsIntangible as IsIntangible,
        p.DirectSourcingModel
    from "KNSUnifiedMDM"."prod"."stg_salsify__Product" p
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Item" i
    on p.MainSku = i.Number
    left join styles s
    on p.Style = s.Name
    left join sizes sz
    on p.MainSku = sz.Number
),

unioned as (
    select * from supplies
    union all
    select * from variants
),

final as (
    select 
        Number,
        Code,
        StyleId,
        SizeId,
        Status,
        SellingStatus,
        ShoeWidth,
        CalfWidth,
        Parent,
        ClosureType,
        HeelType,
        StyleType,
        SizeRun,
        ColorName,
        ColorClass,
        Subclass,
        VendorSku,
        IsAnaplanActive,
        SellOutTargetAt,
        PlannedArrivalAt,
        FirstSalesDateAt,
        MSRP,
        IsSupplies,
        IsIntangible,
        DirectSourcingModel
    from unioned
)

select * from final