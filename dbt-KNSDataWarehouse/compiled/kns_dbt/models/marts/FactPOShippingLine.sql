
  


with 

po_lines as (
    select
        PONumber,
        ItemId,
        TransactionId,
        TransactionLineId,
        RequestedXFAt,
        ConfirmedXFAt,
        ActualXFAt,
        RequestedInDCAt,
        EstimatedInDCAt,
        Quantity as POQuantity,
        QuantityOnShipments as POQuantityOnShipments,
        Rate,
        Season,
        IsOpen
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__PurchaseOrderLine"
),

freight_container_lines as (
    select
        TransactionLineId,
        FreightContainerLineId,
        Container,
        DepartureAt,
        ExpectedInDCAt,
        ActualInDCAt,
        ExpectedQuantity,
        ReceivedQuantity,
        RemainingQuantity
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FreightContainerLine"
),

final as (
    select 
        concat(p.TransactionLineId, '-', f.FreightContainerLineId) as POShippingLineId,
        p.PONumber,
        p.ItemId,
        p.TransactionId,
        p.TransactionLineId,
        p.RequestedXFAt,
        p.ConfirmedXFAt,
        p.ActualXFAt,
        p.RequestedInDCAt,
        p.POQuantity,
        p.POQuantityOnShipments,
        f.FreightContainerLineId,
        f.Container,
        f.DepartureAt,
        coalesce(f.ExpectedInDCAt, p.EstimatedInDCAt) as ExpectedInDCAt,
        f.ActualInDCAt,
        f.ExpectedQuantity,
        f.ReceivedQuantity,
        coalesce(f.RemainingQuantity, p.POQuantity) as RemainingQuantity,
        case 
            when datediff(day, getdate(), coalesce(f.ExpectedInDCAt, p.RequestedInDCAt)) >= 61 
                then '61+ Days'
            when datediff(day, getdate(), coalesce(f.ExpectedInDCAt, p.RequestedInDCAt)) >= 31 
                then '31-60 Days'
            when datediff(day, getdate(), coalesce(f.ExpectedInDCAt, p.RequestedInDCAt)) > 0
                then '<30 Days'
            when f.ActualInDCAt is not null and f.ReceivedQuantity <> f.ExpectedQuantity
                then 'At Warehouse Not Received'
            else 'Past Receive Date'
        end as ReceiveByDateGrouping,
        p.Rate,
        p.Season,
        p.IsOpen
    from po_lines p
    left join freight_container_lines f
        on p.TransactionLineId = f.TransactionLineId
    where p.IsOpen = 1
)

select * from final