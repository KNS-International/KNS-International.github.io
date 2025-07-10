
  


with

netsuite as (
    	select
		ap.enddate as MonthEndAt,
		nsBrand.name as Catalog,
		nsClass.name Class,
		nsSubClass.name Subclass,
		e.entityid as Partner,
        e.id as PartnerId,
		iif(a.acctnumber in ('4000', '4050'), -coalesce(tl.rate * tl.Quantity, tl.NetAmount), 0) as Gross,
		iif(a.acctnumber in ('4100', '4101', '4102', '4103', '4104', '4105', '4106'), coalesce(tl.rate * tl.Quantity, tl.NetAmount), 0) as NetDeductions
	from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionLine" tl on tl.[transaction] = t.id
	left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__CustomrecordCsegKnsBrand2024" nsBrand on nsBrand.id = coalesce(tl.CsegKnsBrand2024, t.CsegKnsBrand2024)
	left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__CustomrecordCsegKnsProductcat" nsClass on nsClass.id = coalesce(tl.CsegKnsProductCat, t.CsegKnsProductCat)
	left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__CustomrecordCsegKnsProdSubcl" nsSubClass on nsSubClass.id = coalesce(tl.CsegKnsProdSubcl, t.CsegKnsProdSubcl)
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Entity" e on e.id = coalesce(tl.Entity, t.Entity)
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Account" a on a.id = tl.expenseaccount
	join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__AccountingPeriod" ap on ap.enddate = EOMONTH(t.trandate)
	where ap.alllocked = 'T'
	and ap.isposting = 'T'
	and a.acctnumber in ('4000', '4050', '4100', '4101', '4102', '4103', '4104', '4105', '4106')
	group by 
		ap.enddate,
		nsBrand.name,
		nsClass.name,
		nsSubClass.name,
		e.entityid,
        e.id,
		iif(a.acctnumber in ('4000', '4050'), -coalesce(tl.rate * tl.Quantity, tl.NetAmount), 0),
		iif(a.acctnumber in ('4100', '4101', '4102', '4103', '4104', '4105', '4106'), coalesce(tl.rate * tl.Quantity, tl.NetAmount), 0),
		t.id,
		t.tranid,
		tl.uniquekey,
		a.acctnumber
),

final as (
    select 
        n.MonthEndAt,
        tp.TradingPartnerId,
        n.Catalog,
        n.Class,
        n.Subclass,
        round((sum(n.Gross) - sum(n.NetDeductions)) / 
        nullif(sum(n.Gross), 0), 2) as GrossToNetPercentage
    from netsuite n
    left join "KNSDataWarehouse"."Deposco"."DimTradingPartner" tp
    on n.Partner = tp.Name
        or (tp.Code = 'FV' and n.PartnerId = 755)
	    or (tp.Code = 'FT' and n.PartnerId = 1497) 
    where Catalog is not null
    and Class is not null
    and Subclass is not null
    and tp.TradingPartnerId is not null
    group by 
        n.MonthEndAt,
        tp.TradingPartnerId,
        n.Catalog,
        n.Class,
        n.Subclass
    having sum(n.Gross) > 0
)

select * from final