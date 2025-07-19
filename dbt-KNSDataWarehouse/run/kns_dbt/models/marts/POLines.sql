
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_marts"."POLines__dbt_tmp__dbt_tmp_vw" as with 

receipt_dates as (
	select
		Id,
		(
			select
				max(t2.TranDate)
			from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionLine" tl2
			join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t2 on t2.Id = tl2.[Transaction]
			where tl2.CreatedFrom = t.Id
			and t2.Type = ''ItemRcpt''
		) as ReceiptDate
	from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t
	where (
			select
				max(t2.TranDate)
			from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionLine" tl2
			join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t2 on t2.Id = tl2.[Transaction]
			where tl2.CreatedFrom = t.Id
			and t2.Type = ''ItemRcpt''
		) is not null
),

netsuite as (
    	select
		tl.UniqueKey as TransactionLineId,
		t.Id as TransactionId,
		t.DueDate as ReceiveByDate,
		rd.ReceiptDate as ReceiptDate,
		tl.Quantity as Quantity,
		case
			when tl.IsClosed = ''T'' or ts.Name = ''Closed''
			 then 0 
			else tl.Quantity - tl.QuantityShipRecv
		end as QuantityRemaining,
		tl.QuantityShipRecv as QuantityReceived,
		t.CustbodyKnsPo as TranId,
		cast(tl.Rate as decimal(19,2)) as Rate,
		i.ExternalId as Item,
		t.CustbodyKnsSeasonPo as Season,
		cast(t.CustbodyKnsXFactoryDate as date) as RequestedXF,
		cast(t.CustbodyKnsConfirmXFact as date) as ConfirmedXF,
		cast(t.CustbodyKnsActualXFact as date) as ActualXF,
		t.DueDate as RequestedInDC,
		cast(t.CustbodyKnsEstInDCDate as date) as EstimatedInDC
	from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionLine" tl 
		on tl.[Transaction] = t.Id
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionStatus" ts 
		on ts.Id = t.Status and ts.TranType = t.Type
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Item" i 
		on i.Id = tl.Item
	left join receipt_dates rd 
		on rd.Id = t.Id
	where t.Type=''PurchOrd''
	and t.DueDate is not null
),

cutoff as (
  select dateadd(month, -1, dateadd(month, datediff(month, 0, min(ReceiveByDate)), 0)) as cutoff_date
  from netsuite
  where QuantityRemaining > 0
),

po_lines as (
	select
		n.TransactionLineId,
		n.TransactionId, -- t.id
		n.ReceiveByDate,
		n.ReceiptDate,
		n.RequestedXF,
		n.ConfirmedXF,
		n.ActualXF,
		n.RequestedInDC,
		n.EstimatedInDC,
		i.ItemId as ItemId,
		n.Quantity,
		n.QuantityRemaining,
		n.QuantityReceived,
		n.TranId,
		n.Rate,
		0 as IsClosed,
		n.Season,
		case
			when n.ReceiveByDate < c.cutoff_date then 0
			else 1
		end as IsTracking,
		coalesce(ish.VesselNumber, null) as FreightForwarderContainer
	from netsuite n
	join "KNSDataWarehouse"."Deposco"."DimItem" i 
		on i.Number = n.Item
	left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__InboundShipmentItem" ishi 
		on ishi.ShipmentItemTransactionId = n.TransactionLineId
	left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__InboundShipment" ish
		on ish.Id = ishi.InboundShipmentId
	cross join cutoff c
)

select * from po_lines;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_prod_marts"."POLines__dbt_tmp" FROM "KNSDevDbt"."dbt_prod_marts"."POLines__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_prod_marts.POLines__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_prod_marts_POLines__dbt_tmp_cci'
        AND object_id=object_id('dbt_prod_marts_POLines__dbt_tmp')
    )
    DROP index "dbt_prod_marts"."POLines__dbt_tmp".dbt_prod_marts_POLines__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_prod_marts_POLines__dbt_tmp_cci
    ON "dbt_prod_marts"."POLines__dbt_tmp"

   


  