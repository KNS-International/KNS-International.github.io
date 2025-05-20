




with ids as (
    select
        Name,
        TradingPartnerId
    from "KNSUnifiedMDM"."Orders"."TradingPartner"
),

info as (
    select
        Name,
        HandlingFee,
        HandlingFeeType
    from "KNSUnifiedMDM"."prod"."stg_deposco__TradingPartner"
),

joined as (
    select
        ids.TradingPartnerId,
        info.HandlingFeeType,
        info.HandlingFee
    from ids 
    left join info
    on ids.Name = info.Name
),

latest as (
    select * from "KNSUnifiedMDM"."Orders"."TradingPartnerHandlingFee"
    where EndDate is null
),

new as (
    select
        j.TradingPartnerId,
        cast(getdate() as date) as StartDate,
        null as EndDate,
        j.HandlingFeeType,
        j.HandlingFee
    from joined j
    left join latest l
    on j.TradingPartnerId = l.TradingPartnerId
    where l.TradingPartnerId is null 
        or j.HandlingFee != l.HandlingFee
        or l.HandlingFeeType != j.HandlingFeeType
),

expired as (
    select
        l.TradingPartnerId,
        l.StartDate,
        cast(getdate() as date) as EndDate,
        l.HandlingFeeType,
        l.HandlingFee
    from latest l
    left join joined j
    on l.TradingPartnerId = j.TradingPartnerId
    where j.TradingPartnerId is null 
        or j.HandlingFee != l.HandlingFee
        or j.HandlingFeeType != l.HandlingFeeType
),

final as (
    select * from new
    union all
    select * from expired
)

select * from final