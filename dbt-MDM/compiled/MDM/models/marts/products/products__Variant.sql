

with styles as ( 
    select * from Products.Style
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
        AnaplanActive as IsAnaplanActive,
        case 
            when SellOutTargetDateYear is not null and SellOutTargetDateMonth is not null
            then datefromparts(SellOutTargetDateYear, SellOutTargetDateMonth, 1)
            else null
        end as SellOutTargetAt,
        PlannedArrivalDateMonth as PlannedArrivalAt,
        FirstSalesDateAt,
        MSRP,
        iif(i.IsSupplies like '%suppl%', 1, 0) as IsSupplies,
        i.IsIntangible as IsIntangible,
        DirectSourcingModel,
        Style,
        row_number() over (partition by MainSku order by (select null)) as rn
    from "KNSUnifiedMDM"."prod"."stg_salsify__Product" p
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Item" i
    on p.MainSku = i.Number
    where MainSku is not null
        and MainSku != ''
),

final as (
    select 
        Number,
        null as Code,
        s.StyleId,
        null as SizeId,
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
        v.IsAnaplanActive,
        v.SellOutTargetAt,
        v.PlannedArrivalAt,
        v.FirstSalesDateAt,
        v.MSRP,
        v.IsSupplies,
        v.IsIntangible,
        v.DirectSourcingModel
    from variants v
    left join styles s
    on v.Style = s.Name
    where rn = 1
)

select * from final