
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."POAggregate__dbt_tmp__dbt_tmp_vw" as 
  


with

inventory_valuation as (
    select 
        Date,
        ItemId,
        Quantity,
        Valuation 
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__InventoryValuation"
),

latest_inventory_date as (
    select
        ItemId,
        max(Date) as LatestInventoryDate
    from inventory_valuation
    group by ItemId
),

latest_inventory as (
    select
        iv.ItemId,
        iv.Date as LatestInventoryDate,
        iv.Quantity as LatestInventoryQuantity
    from inventory_valuation iv
    join latest_inventory_date lid
        on iv.ItemId = lid.ItemId
       and iv.Date = lid.LatestInventoryDate
),

inventory_12mo_prior_date as (
    select
        iv.ItemId,
        max(iv.Date) as MaxInventoryDate12MoPrior
    from inventory_valuation iv
    join latest_inventory li on iv.ItemId = li.ItemId
    where iv.Date <= dateadd(month, -12, li.LatestInventoryDate)
    group by iv.ItemId
),

inventory_12mo_prior as (
    select
        iv.ItemId,
        iv.Date as MaxInventoryDate12MoPrior,
        iv.Quantity as Quantity12MoPrior
    from inventory_valuation iv
    join inventory_12mo_prior_date prior
        on iv.ItemId = prior.ItemId
       and iv.Date = prior.MaxInventoryDate12MoPrior
),

all_inventory_dates as (
    select
        ItemId,
        LatestInventoryDate as InventoryDate,
        ''Latest'' as DateType
    from latest_inventory

    union all

    select
        ItemId,
        MaxInventoryDate12MoPrior as InventoryDate,
        ''12MoPrior'' as DateType
    from inventory_12mo_prior
),

po_lines as (
    select 
        ItemId,
        ActualInDCAt as ReceiptDate,
        ReceivedQuantity as Quantity 
    from "KNSDataWarehouse"."KNS"."FactPOShippingLine"
),

inventory_receipts as (
    select
        p.ItemId,
        a.DateType,
        case
            when datediff(month, p.ReceiptDate, a.InventoryDate) between 0 and 6 then ''0-6 months''
            when datediff(month, p.ReceiptDate, a.InventoryDate) between 7 and 12 then ''7-12 months''
            when datediff(month, p.ReceiptDate, a.InventoryDate) between 13 and 24 then ''13-24 months''
            when datediff(month, p.ReceiptDate, a.InventoryDate) between 25 and 36 then ''25-36 months''
            when datediff(month, p.ReceiptDate, a.InventoryDate) > 36 then ''36+ months''
            else ''Unknown''
        end as AgeBucket,
        sum(p.Quantity) as ReceiptsQuantity
    from po_lines p
    join all_inventory_dates a on p.ItemId = a.ItemId
    group by
        p.ItemId,
        a.DateType,
        case
            when datediff(month, p.ReceiptDate, a.InventoryDate) between 0 and 6 then ''0-6 months''
            when datediff(month, p.ReceiptDate, a.InventoryDate) between 7 and 12 then ''7-12 months''
            when datediff(month, p.ReceiptDate, a.InventoryDate) between 13 and 24 then ''13-24 months''
            when datediff(month, p.ReceiptDate, a.InventoryDate) between 25 and 36 then ''25-36 months''
            when datediff(month, p.ReceiptDate, a.InventoryDate) > 36 then ''36+ months''
            else ''Unknown''
        end
),

pivoted_receipts as (
    select
        ItemId,
        DateType,
        sum(case when AgeBucket = ''0-6 months'' then ReceiptsQuantity else 0 end) as ''0-6 months'',
        sum(case when AgeBucket = ''7-12 months'' then ReceiptsQuantity else 0 end) as ''7-12 months'',
        sum(case when AgeBucket = ''13-24 months'' then ReceiptsQuantity else 0 end) as ''13-24 months'',
        sum(case when AgeBucket = ''25-36 months'' then ReceiptsQuantity else 0 end) as ''25-36 months'',
        sum(case when AgeBucket = ''36+ months'' then ReceiptsQuantity else 0 end) as ''36+ months''
    from inventory_receipts
    group by ItemId, DateType
),

final_with_dates as(
    select
        pr.*,
        aid.InventoryDate
    from pivoted_receipts pr
    join all_inventory_dates aid
        on pr.ItemId = aid.ItemId
       and pr.DateType = aid.DateType
),

final as (
    select
        f.ItemId,
        f.DateType,
        f.[0-6 months],
        f.[7-12 months],
        f.[13-24 months],
        f.[25-36 months],
        f.[36+ months],
        iv.Valuation,
        iv.Quantity,
        case
            when iv.Quantity = 0 then 0
            else cast(iv.Valuation / cast(iv.Quantity as decimal(18, 2)) as decimal(18, 2))
        end as [Unit Value]
    from final_with_dates f
    join inventory_valuation iv
        on iv.ItemId = f.ItemId
       and iv.Date = f.InventoryDate
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."POAggregate__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."POAggregate__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.POAggregate__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_POAggregate__dbt_tmp_cci'
        AND object_id=object_id('KNS_POAggregate__dbt_tmp')
    )
    DROP index "KNS"."POAggregate__dbt_tmp".KNS_POAggregate__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_POAggregate__dbt_tmp_cci
    ON "KNS"."POAggregate__dbt_tmp"

   


  