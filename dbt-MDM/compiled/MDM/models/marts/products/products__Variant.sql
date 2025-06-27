



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
        p.Color as ColorName,
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
        p.DirectSourcingModel,
        p.DtcWebsiteColor as DtcWebsiteColor
        -- row_number() over (partition by MainSku order by (select null)) as rn
    from "KNSUnifiedMDM"."prod"."stg_salsify__Product" p
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Item" i
    on p.MainSku = i.Number
    left join styles s
    on p.Style = s.Name
    left join sizes sz
    on p.MainSku = sz.Number
    -- where MainSku is not null
    --     and MainSku != ''
),

-- variant_deduped as (
--     select 
--         v.Number,
--         null as Code,
--         s.StyleId,
--         sz.SizeId,
--         v.Status,
--         v.SellingStatus,
--         v.ShoeWidth,
--         v.CalfWidth,
--         v.Parent,
--         v.ClosureType,
--         v.HeelType,
--         v.StyleType,
--         v.SizeRun,
--         v.ColorName,
--         v.ColorClass,
--         v.Subclass,
--         v.VendorSku,
--         v.IsAnaplanActive,
--         v.SellOutTargetAt,
--         v.PlannedArrivalAt,
--         v.FirstSalesDateAt,
--         v.MSRP,
--         v.IsSupplies,
--         v.IsIntangible,
--         v.DirectSourcingModel,
--         v.DtcWebsiteColor
--     from variants v
--     left join styles s
--     on v.Style = s.Name
--     left join sizes sz
--     on v.Number = sz.Number
--     where rn = 1
-- ),

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
        DirectSourcingModel,
        DtcWebsiteColor
    from unioned
)

select * from final