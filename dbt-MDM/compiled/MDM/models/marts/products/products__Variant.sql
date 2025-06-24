



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
        null as DirectSourcingModel,
        null as DtcWebsiteColor
    from "KNSUnifiedMDM"."prod"."stg_deposco__Item" i
    where IsSupplies like '%suppl%'
        and CompanyId = 73
),

sizes as (
    select * from "KNSUnifiedMDM"."prod"."int_products__Size"
),

variants as (
    select 
        MainSku as Number,
        null as Code,
        Status,
        SellingStatus,
        ShoeWidth,
        CalfWidth,
        ParentSku as Parent,
        ClosureType,
        HeelHeight as HeelType,
        StyleType,
        SizeRun,
        Color as ColorName,
        ColorClass,
        MerchandiseSubclass as Subclass,
        VendorSku,
        AnaplanActive as IsAnaplanActive,
        case 
            when SellOutTargetDateYear is not null and SellOutTargetDateMonth is not null
            then datefromparts(SellOutTargetDateYear, SellOutTargetDateMonth, 1)
            else null
        end as SellOutTargetAt,
        PlannedArrivalDateMonth as PlannedArrivalAt,
        FirstSalesDateAt,
        MSRP,
        0 as IsSupplies,
        i.IsIntangible as IsIntangible,
        DirectSourcingModel,
        Style,
        DtcWebsiteColor as DtcWebsiteColor,
        row_number() over (partition by MainSku order by (select null)) as rn
    from "KNSUnifiedMDM"."prod"."stg_salsify__Product" p
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Item" i
    on p.MainSku = i.Number
    where MainSku is not null
        and MainSku != ''
),

variant_deduped as (
    select 
        v.Number,
        null as Code,
        s.StyleId,
        sz.SizeId,
        v.Status,
        v.SellingStatus,
        v.ShoeWidth,
        v.CalfWidth,
        v.Parent,
        v.ClosureType,
        v.HeelType,
        v.StyleType,
        v.SizeRun,
        v.ColorName,
        v.ColorClass,
        v.Subclass,
        v.VendorSku,
        v.IsAnaplanActive,
        v.SellOutTargetAt,
        v.PlannedArrivalAt,
        v.FirstSalesDateAt,
        v.MSRP,
        v.IsSupplies,
        v.IsIntangible,
        v.DirectSourcingModel,
        v.DtcWebsiteColor
    from variants v
    left join styles s
    on v.Style = s.Name
    left join sizes sz
    on v.Number = sz.Number
    where rn = 1
),

unioned as (
    select * from supplies
    union all
    select * from variant_deduped
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
        DirectSourcingModel,
        DtcWebsiteColor
    from unioned
)

select * from final