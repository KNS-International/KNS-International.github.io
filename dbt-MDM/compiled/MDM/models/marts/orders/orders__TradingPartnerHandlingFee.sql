



with

info as (
    select
        Name,
        TradingPartnerId,
        HandlingFee,
        HandlingFeeType
    from "KNSUnifiedMDM"."prod"."stg_deposco__TradingPartner"
),

latest as (
    select * from "KNSUnifiedMDM"."Orders"."TradingPartnerHandlingFee"
    where EndDate is null
),

new as (
    select
        i.TradingPartnerId,
        cast(getdate() as date) as StartDate,
        null as EndDate,
        i.HandlingFeeType,
        i.HandlingFee
    from info i
    left join latest l
    on i.TradingPartnerId = l.TradingPartnerId
    where l.TradingPartnerId is null 
        or i.HandlingFee != l.HandlingFee
        or i.HandlingFeeType != l.HandlingFeeType
),

expired as (
    select
        l.TradingPartnerId,
        l.StartDate,
        cast(getdate() as date) as EndDate,
        l.HandlingFeeType,
        l.HandlingFee
    from latest l
    left join info i
    on l.TradingPartnerId = i.TradingPartnerId
    where i.TradingPartnerId is null 
        or i.HandlingFee != l.HandlingFee
        or i.HandlingFeeType != l.HandlingFeeType
),

final as (
    select * from new
    union all
    select * from expired
)

select * from final