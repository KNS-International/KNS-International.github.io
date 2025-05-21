



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
        oh.OrderHeaderId as SourceId,
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
        null as FreightOutCOGSAmount,
        oh.DiscountAmount
    from order_header oh
    left join "KNSUnifiedMDM"."prod"."stg_deposco__ShipmentOrderHeader" soh 
    on oh.OrderHeaderId = soh.OrderHeaderId
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Shipment" s
    on soh.ShipmentId = s.ShipmentId
    left join "KNSUnifiedMDM"."prod"."stg_deposco__TradingPartner" dtp 
    on oh.TradingPartnerId = dtp.TradingPartnerId
    left join "KNSUnifiedMDM"."Orders"."TradingPartner" tp
    on dtp.Name = tp.Name
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

-- final as (

--     select
--         oh.CustomerOrderNumber as PONumber,
--         tp.*,
--         oh.PlacedAt,
--         oh.ContractualShipAt,
--         oh.PlannedShipAt,
--         case
--             when oh.ShippingStatus = 20 then 'Closed'
--             else 'Open'
--         end as Status,
--         oh.OrderHeaderId as SourceId,
--         'Deposco' as SourceSystem,
--         s.ShippingVia,
--         case
--             when s.ShippingVia like '%easypost%' then 'USPS'
--             when s.ShippingVia like '%stamps%' then 'USPS'
--             when s.ShippingVia like '%fedex%' then 'FedEx'
--             when s.ShippingVia like '%UPS%' or s.ShippingVia = 'USG' then 'UPS'
--             when s.ShippingVia like '%landmark%' then 'Landmark'
--         end as ShippingCarrier,
--         oh.ShippedAt,
--         oh.DiscountAmount,
--         soh.*
--     from order_header oh
--     left join "KNSUnifiedMDM"."prod"."stg_deposco__ShipmentOrderHeader" soh 
--     on oh.OrderHeaderId = soh.OrderHeaderId
--     left join "KNSUnifiedMDM"."prod"."stg_deposco__Shipment" s
--     on soh.ShipmentId = s.ShipmentId
--     left join "KNSUnifiedMDM"."prod"."stg_deposco__TradingPartner" dtp 
--     on oh.TradingPartnerId = dtp.TradingPartnerId
--     left join "KNSUnifiedMDM"."Orders"."TradingPartner" tp
--     on dtp.Name = tp.Name
    
-- )

select * from final