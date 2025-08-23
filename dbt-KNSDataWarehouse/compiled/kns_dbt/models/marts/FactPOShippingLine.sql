
  


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
        RemainingQuantityNotOnShipments,
        Rate,
        Season,
        IsOpen,
        TransactionDate
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

joined as (
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
            when f.ActualInDCAt is not null or f.ReceivedQuantity > 0
                then cast(1 as bit)
            else cast(0 as bit)
        end as IsArrived,
        case 
            when f.ActualInDCAt is not null 
                 and datediff(day, f.ActualInDCAt, getdate()) between 0 and 14
                then cast(1 as bit)
            else cast(0 as bit)
        end as IsRecentlyReceived,
        p.Rate,
        p.Season,
        p.IsOpen
    from po_lines p
    left join freight_container_lines f
        on p.TransactionLineId = f.TransactionLineId
    where p.TransactionDate >= datefromparts(year(getdate()) - 1, 1, 1)
),

unassigned as (
    select
        concat(p.TransactionLineId, '-', cast(null as varchar(50))) as POShippingLineId,
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
        cast(null as bigint) as FreightContainerLineId,
        cast(null as varchar(50)) as Container,
        cast(null as datetime) as DepartureAt,
        p.EstimatedInDCAt as ExpectedInDCAt,
        cast(null as datetime) as ActualInDCAt,
        cast(null as decimal(18,4)) as ExpectedQuantity,
        cast(0 as decimal(18,4)) as ReceivedQuantity,
        cast(p.RemainingQuantityNotOnShipments as decimal(18,4)) as RemainingQuantity,
        cast(0 as bit) as IsArrived,
        cast(0 as bit) as IsRecentlyReceived,
        p.Rate,
        p.Season,
        p.IsOpen
    from po_lines p
    where p.TransactionDate >= datefromparts(year(getdate()) - 1, 1, 1)
      and p.RemainingQuantityNotOnShipments > 0
      and exists (
            select 1
            from freight_container_lines f
            where f.TransactionLineId = p.TransactionLineId
      )
),

unioned as (
    select * from joined
    union all
    select * from unassigned
),

final as (
    select
        POShippingLineId,
        PONumber,
        ItemId,
        TransactionId,
        TransactionLineId,
        RequestedXFAt,
        ConfirmedXFAt,
        ActualXFAt,
        RequestedInDCAt,
        coalesce(ExpectedQuantity, POQuantity-ISNULL(POQuantityOnShipments, 0)) as Quantity,
        FreightContainerLineId,
        Container,
        DepartureAt,
        ExpectedInDCAt,
        ActualInDCAt,
        ReceivedQuantity,
        RemainingQuantity,
        case 
            when datediff(day, getdate(), coalesce(ExpectedInDCAt, RequestedInDCAt)) >= 61 
                then '61+ Days'
            when datediff(day, getdate(), coalesce(ExpectedInDCAt, RequestedInDCAt)) >= 31 
                then '31-60 Days'
            when datediff(day, getdate(), coalesce(ExpectedInDCAt, RequestedInDCAt)) > 0
                then '<30 Days'
            when ActualInDCAt is not null and ReceivedQuantity <> ExpectedQuantity
                then 'At Warehouse Not Received'
            when RemainingQuantity = 0
                then 'Received'
            else 'Past Receive Date'
        end as ReceiveByDateGrouping,
        IsArrived,
        IsRecentlyReceived,
        Rate,
        Season,
        IsOpen
    from unioned
)

select * from final