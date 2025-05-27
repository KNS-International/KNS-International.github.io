




with order_line as (
    select
        OrderLineId as SourceId,
        PackId,
        OrderHeaderId as OrderSourceId,
        ItemId,
        OrderPackQuantity,
        CanceledPackQuantity,
        UnitCost,
        OrderLineStatus
    from "KNSUnifiedMDM"."prod"."stg_deposco__OrderLine"
),

invoice_header as (
    select 
        OrderHeaderId,
        Number,
        concat('DEP_INV', InvoiceHeaderId) as InvoiceHeaderId,
        row_number() over (
            partition by OrderHeaderId
            order by InvoiceHeaderId
        ) as rn
    from "KNSUnifiedMDM"."prod"."stg_deposco__InvoiceHeader"
),

invoice_header_deduped as (
  select 
    OrderHeaderId,
    InvoiceHeaderId,
    Number
  from invoice_header
  where rn = 1
),

net_invoices as (
    select 
        t.TranId as InvoiceId,
        t.CustBodyKnsPo as PO1,
        t.OtherRefNum as PO2,
        t.Entity,
        t.TranDate,
        convert(decimal(19,4), coalesce(max(tl.Rate), 0)) as UnitItemCOGSAmount,
        i.externalid as ItemNumber
    from "KNSUnifiedMDM"."prod"."stg_netsuite__Transaction" t
    join "KNSUnifiedMDM"."prod"."stg_netsuite__Entity" e
    on t.entity = e.id
    join "KNSUnifiedMDM"."prod"."stg_netsuite__TransactionLine" tl
    on t.id = tl.TransactionId
    join "KNSUnifiedMDM"."prod"."stg_netsuite__Item" i
    on tl.item = i.id
    where tl.ExpenseAccount = 214
    group by 
        t.TranId,
        t.CustBodyKnsPo,
        t.OtherRefNum,
        t.Entity,
        t.TranDate,
        i.externalid
),

final as (

    select
        ol.SourceId,
        so.SalesOrderId,
        v.VariantId as ProductVariantId,
        ol.OrderPackQuantity * p.Quantity as QuantityOrdered,
        iif(
            oh.ShippingStatus = 20,
            (ol.OrderPackQuantity * p.Quantity) - iif(
                    ol.OrderLineStatus in ('Canceled', 'Cancelled'),
                    ol.OrderPackQuantity * p.Quantity,
                    ol.CanceledPackQuantity * p.Quantity
                ),
            0
        ) as QuantityShipped,
        iif(
            ol.OrderLineStatus in ('Canceled', 'Cancelled')
                or oh.CurrentStatus in ('Canceled', 'Cancelled'),
            ol.OrderPackQuantity * p.Quantity,
            ol.CanceledPackQuantity * p.Quantity
        ) as QuantityCanceled,
        ol.UnitCost as UnitCostAmount,
        n.UnitItemCOGSAmount
    from order_line ol
    join "KNSUnifiedMDM"."prod"."stg_deposco__OrderHeader" oh
    on ol.OrderSourceId = oh.OrderHeaderId
    left join "KNSUnifiedMDM"."Orders"."SalesOrder" so
    on ol.OrderSourceId = so.SourceId
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Item" i
    on ol.ItemId = i.ItemId
    left join "KNSUnifiedMDM"."Products"."Variant" v
    on i.Number = v.Number
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Pack" p
    on ol.PackId = p.PackId
    left join invoice_header_deduped ih
    on ol.OrderSourceId = ih.OrderHeaderId
    left join net_invoices n
    on ih.InvoiceHeaderId = n.InvoiceId and v.Number = n.ItemNumber
    
)

select * from final