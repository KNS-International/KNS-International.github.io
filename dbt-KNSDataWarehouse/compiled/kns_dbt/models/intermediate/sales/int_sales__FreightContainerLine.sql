with

shipments as (
    select
        si.Id as FreightContainerLineId,
        t.CustBodyKnsPo as PONumber,
        s.ActualShippingDate as DepartureAt,
        cast(t.CustBodyKnsActualXFact as date) as ActualXFAt,
        s.ActualDeliveryDate as ActualInDCAt,
        coalesce(s.ExpectedDeliveryDate, t.DueDate) as ExpectedInDcAt,
        si.QuantityExpected as ExpectedQuantity,
        si.QuantityReceived as ReceivedQuantity,
        i.ExternalId as Item,
        s.VesselNumber as Container,
        si.ShipmentItemTransactionId as TransactionLineId
    from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__InboundShipment" s 
    left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__InboundShipmentItem" si 
        on s.Id = si.InboundShipmentId
    left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionLine" tl
        on si.ShipmentItemTransactionId = tl.UniqueKey
    left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t
        on tl.[Transaction] = t.Id
    left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Item" i
        on tl.Item = i.Id
),

final as (
    select 
        s.FreightContainerLineId,
        s.Container,
        s.PONumber,
        s.TransactionLineId,
        s.ActualXFAt,
        s.DepartureAt,
        s.ExpectedInDCAt,
        s.ActualInDCAt,
        s.ExpectedQuantity,
        s.ExpectedQuantity - s.ReceivedQuantity as RemainingQuantity,
        s.ReceivedQuantity,
        i.ItemId
    from shipments s
    left join "KNSDataWarehouse"."Deposco"."DimItem" i
        on s.Item = i.Number
)

select * from final