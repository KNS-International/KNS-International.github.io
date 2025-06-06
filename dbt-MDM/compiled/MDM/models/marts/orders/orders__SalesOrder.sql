



with order_header as (
    select
        CustomerOrderNumber,
        TradingPartnerId,
        PlacedAt,
        ContractualShipAt,
        PlannedShipAt,
        ShippingStatus,
        OrderHeaderId,
        ShippedAt,
        DiscountAmount
    from "KNSUnifiedMDM"."prod"."stg_deposco__OrderHeader"
    where CurrentStatus not in ('Void', 'Voided')
),

kns_accounts as (
    select
        cast(FedexAccountNumber as nvarchar(32)) as FedexAccountNumber,
        cast(UpsAccountNumber as nvarchar(32)) as UpsAccountNumber
    from "KNSUnifiedMDM"."prod"."stg_deposco__TradingPartner"
    where Code = 'KNS'
),

fedex_json as (
    select
        ip.TradingPartnerId,
        j.value as FedexAccountFromJson
    from "KNSUnifiedMDM"."prod"."stg_deposco__IntegrationPoint" ip
    cross apply openjson(ip.Properties, '$.attributes') j
    where ip.Type = 'fedex'
      and ip.IsEnabled = 1
      and j.[key] = 'accountNumber'
),

final as (

    select
        oh.CustomerOrderNumber as PONumber,
        tp.TradingPartnerId,
        oh.PlacedAt,
        oh.ContractualShipAt,
        oh.PlannedShipAt,
        case
            when oh.ShippingStatus = 20 then 'Closed'
            else 'Open'
        end as Status,
        cast(oh.OrderHeaderId as nvarchar(50)) as SourceId,
        'Deposco' as SourceSystem,
        min(iif(s.Status='Shipped', s.ShippingVia, null)) as ShippingVia,
        min(case
            when s.ShippingVia like '%easypost%' then 'USPS'
            when s.ShippingVia like '%stamps%' then 'USPS'
            when s.ShippingVia like '%fedex%' then 'FedEx'
            when s.ShippingVia like '%UPS%' or s.ShippingVia = 'USG' then 'UPS'
            when s.ShippingVia like '%landmark%' then 'Landmark'
        end) as ShippingCarrier,
        oh.ShippedAt,
        sum(case
            when s.FreightTermsType = 'Third Party' 
                then iif(s.FreightBillToAccount = ka.FedexAccountNumber or s.FreightBillToAccount = ka.UpsAccountNumber, s.ShippingCost, 0)
            when s.ShippingVia like '%ups%' or s.ShippingVia like '%usg%' 
                then iif(right(left(iif(s.TrackingNumber like '1Z%', s.TrackingNumber, null), 8), 6) = ka.UpsAccountNumber, s.ShippingCost, 0)
            when s.ShippingVia like '%fedex%' 
                then iif(coalesce(fj.FedexAccountFromJson, dtp.FedexAccountNumber, ka.FedexAccountNumber) = ka.FedexAccountNumber, s.ShippingCost, 0)
            else 0
        end) as FreightOutCOGSAmount,
        oh.DiscountAmount
    from order_header oh
    cross join kns_accounts ka
    left join "KNSUnifiedMDM"."prod"."stg_deposco__ShipmentOrderHeader" soh 
    on oh.OrderHeaderId = soh.OrderHeaderId
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Shipment" s
    on soh.ShipmentId = s.ShipmentId
    left join "KNSUnifiedMDM"."prod"."stg_deposco__TradingPartner" dtp 
    on oh.TradingPartnerId = dtp.TradingPartnerId
    left join "KNSUnifiedMDM"."Orders"."TradingPartner" tp
    on dtp.Name = tp.Name
    left join fedex_json fj
    on fj.TradingPartnerId = dtp.TradingPartnerId
    group by 
        oh.CustomerOrderNumber,
        tp.TradingPartnerId,
        oh.PlacedAt,
        oh.ContractualShipAt,
        oh.PlannedShipAt,
        oh.ShippingStatus,
        oh.OrderHeaderId,
        oh.ShippedAt,
        oh.DiscountAmount
    
)

select * from final