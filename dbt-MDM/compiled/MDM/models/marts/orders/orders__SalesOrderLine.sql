




with order_line as (
    select
        cast(ol.OrderLineId as nvarchar(200)) as SourceId,
        ol.PackId,
        cast(ol.OrderHeaderId as nvarchar(200)) as OrderSourceId,
        ol.ItemId,
        ol.OrderPackQuantity,
        ol.CanceledPackQuantity,
        ol.UnitCost,
        ol.OrderLineStatus,
        'Deposco' as SourceSystem
    from "KNSUnifiedMDM"."prod"."stg_deposco__OrderLine" ol
    left join "KNSUnifiedMDM"."prod"."stg_deposco__Item" i
    on ol.ItemId = i.ItemId
    where ol.OrderLineStatus not in ('Void', 'Voided')
        and i.CompanyId = 73
        and i.ItemId != 102648 -- Exclude 'Invalid Item' item

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
        cast(ol.SourceId as nvarchar(200)) as SourceId,
        so.SalesOrderId,
        v.VariantId as ProductVariantId,
        ol.ItemId,
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
    join "KNSUnifiedMDM"."Orders"."SalesOrder" so
    on ol.OrderSourceId = so.SourceId
        and ol.SourceSystem = so.SourceSystem
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
    where oh.CurrentStatus not in ('Void', 'Voided')
    
)

select * from final
where ItemId != 216975 -- Temporary exlude of test item in deposco
and ItemId !=  217538 -- Temporary exlude of test item in deposco