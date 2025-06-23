USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_intermediate"."int_sales__FactSalesLine_ReturnsAccruals__dbt_tmp" as with 

source as (

    select 
        cast(concat(''Returns Accrual/'', tl.UniqueKey) as nvarchar(255)) as Number,
        171516 as ItemId,
        tp.TradingPartnerId,
        ''Discontinued'' as Brand,
        null as LastUpdatedAt,
        0 as Amount,
        0 as Quantity,
        null as PONumber,
        convert(date, t.TranDate) as PlacedDate,
        convert(date, t.TranDate) as CreatedDate,
        convert(date, t.TranDate) as ContractualShipDate,
        convert(date, t.TranDate) as PlannedShipDate,
        convert(date, t.TranDate) as ActualShipDate,
        ''Complete'' as HeaderCurrentStatus,
        ''Shipped'' as HeaderShippingStatus,
        ''Complete'' as LineStatus,
        0 as FreightOutCOGS,
        coalesce(tl.CreditForeignAmount, 0) - coalesce(tl.DebitForeignAmount, 0) as ItemCOGS,
        0 as HandlingFee,
        0 as DiscountAmount,
        getdate() as RecordUpdatedAt,
        null as Season
    from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionLine" tl
    join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t
        on tl.[Transaction] = t.Id
    join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Entity" e
        on t.Entity = e.Id
    join "KNSDevDbt"."dbt_prod_staging"."stg_orders__TradingPartner" tp
        on e.EntityId = tp.Name
    where tl.Memo = ''Returns Accrual''
        and tl.ExpenseAccount=214
        and (convert(date, eomonth(t.TranDate)) <  dateadd(day, -15, convert(date, SYSDATETIMEOFFSET() at time zone ''mountain standard time'')))

)

select * from source;
    ')

