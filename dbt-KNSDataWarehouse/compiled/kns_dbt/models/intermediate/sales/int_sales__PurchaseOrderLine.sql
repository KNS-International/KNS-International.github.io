with 

netsuite as (
    	select
		tl.UniqueKey as TransactionLineId,
		t.Id as TransactionId,
		t.CustbodyKnsPo as PONumber,
		tl.Quantity as Quantity,
		i.ExternalId as Item,
        cast(tl.Rate as decimal(19,2)) as Rate,
		t.CustbodyKnsSeasonPo as Season,
        cast(t.CustbodyKnsXFactoryDate as date) as RequestedXFAt,
		cast(t.CustbodyKnsConfirmXFact as date) as ConfirmedXFAt,
		cast(t.CustbodyKnsActualXFact as date) as ActualXFAt,
		t.DueDate as RequestedInDCAt,
		cast(t.CustbodyKnsEstInDCDate as date) as EstimatedInDCAt,
        tl.QuantityOnShipments as QuantityOnShipments,
        case
            when tl.Quantity - tl.QuantityShipRecv = 0 
                or tl.IsClosed = 'T'
                or ts.Name = 'Closed'
				or ts.Name = 'Fully Billed'
                then 0
            else 1
        end as IsOpen,
		t.TranDate as TransactionDate
	from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionLine" tl 
		on tl.[Transaction] = t.Id
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionStatus" ts 
		on ts.Id = t.Status and ts.TranType = t.Type
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Item" i 
		on i.Id = tl.Item
	where t.Type='PurchOrd'
	and t.DueDate is not null
	and t.DueDate >= datefromparts(year(getdate()) - 1, 1, 1)
),

po_lines as (
	select
		n.PONumber,
        n.RequestedXFAt,
		n.ConfirmedXFAt,
		n.EstimatedInDCAt,
		n.RequestedInDCAt,
		n.ActualXFAt,
		n.Quantity,
        n.QuantityOnShipments,
		n.Quantity - n.QuantityOnShipments as RemainingQuantityNotOnShipments,
		i.ItemId as ItemId,
		n.TransactionId,
		n.TransactionLineId,
        n.Rate,
        n.Season,
        IsOpen,
		n.TransactionDate
	from netsuite n
	join "KNSDataWarehouse"."Deposco"."DimItem" i 
		on i.Number = n.Item
)

select * from po_lines