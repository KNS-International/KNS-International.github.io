
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactSalesLine__dbt_tmp__dbt_tmp_vw" as 
  


with

budget_subclass as (
  select
    bud.BrandId, 
    bud.TradingPartnerId, 
    bud.Class, bud.Subclass, 
    bud.MonthEndDate,
    sum(iif(bud.IsGrossSales = 1, bud.DailyAmount, 0)) as Gross,
    sum(iif(bud.IsNetAdj = 1, bud.DailyAmount, 0)) as NetAdj,
    (sum(iif(bud.IsGrossSales = 1, bud.DailyAmount, 0)) - sum(iif(bud.IsNetAdj = 1, bud.DailyAmount, 0))) / 
    sum(iif(bud.IsGrossSales = 1, bud.DailyAmount, 0)) as GrossToNetPercentage
  from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__BudgetForecast" bud
  where bud.Identifier = ''Budget''
  group by bud.BrandId, bud.TradingPartnerId, bud.Class, bud.Subclass, bud.MonthEndDate
  having sum(iif(bud.IsGrossSales = 1, bud.DailyAmount, 0)) > 0
),

budget_class as (
  select
    MonthEndDate,
		BrandId,
		TradingPartnerId,
		Class,
		(sum(Gross) - sum(NetAdj)) / sum(Gross) as GrossToNetPercentage
  from budget_subclass
  group by MonthEndDate, BrandId, TradingPartnerId, Class
),

budget_tradingpartner as (
  select
    MonthEndDate,
		BrandId,
		TradingPartnerId,
		(sum(Gross) - sum(NetAdj)) / sum(Gross) as GrossToNetPercentage
  from budget_subclass
  group by MonthEndDate, BrandId, TradingPartnerId
),

budget_brand as (
  select
    MonthEndDate,
		BrandId,
		(sum(Gross) - sum(NetAdj)) / sum(Gross) as GrossToNetPercentage
  from budget_subclass
  group by MonthEndDate, BrandId
),

actuals_subclass as (
  select 
    MonthEndAt,
    TradingPartnerId,
    BrandId,
    Class,
    Subclass,
		GrossSales,
		NetComponents,
    GrossToNetPercentage
  from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FinancialActuals"
),

actuals_class as (
  select
		MonthEndAt,
		BrandId,
		TradingPartnerId,
		Class,
		(sum(GrossSales) - suM(NetComponents)) / sum(GrossSales) as GrossToNetPercentage
	from actuals_subclass
	group by MonthEndAt, BrandId, TradingPartnerId, Class
),

actuals_tradingpartner as (
  select
		MonthEndAt,
		BrandId,
		TradingPartnerId,
		(sum(GrossSales) - suM(NetComponents)) / sum(GrossSales) as GrossToNetPercentage
	from actuals_subclass
	group by MonthEndAt, BrandId, TradingPartnerId
),

returns_accruals as (
  select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_ReturnsAccruals"
),

mdm as (
    select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_MDM" 
),

unioned as (
    select 
        cast(Number as nvarchar(200)) as Number,
        cast(ItemId as int) as ItemId,
        cast(TradingPartnerId as int) as TradingPartnerId,
        cast(Brand as nvarchar(200)) as Brand,
        cast(LastUpdatedAt as datetime) as LastUpdatedAt,
        cast(Amount as decimal(19, 4)) as Amount,
        cast(Quantity as int) as Quantity,
        cast(PONumber as nvarchar(64)) as PONumber,
        cast(PlacedDate as datetime) as PlacedDate,
        cast(CreatedDate as datetime) as CreatedDate,
        cast(ContractualShipDate as datetime) as ContractualShipDate,
        cast(PlannedShipDate as datetime) as PlannedShipDate,
        cast(ActualShipDate as datetime) as ActualShipDate,
        cast(HeaderCurrentStatus as nvarchar(48)) as HeaderCurrentStatus,
        cast(HeaderShippingStatus as nvarchar(48)) as HeaderShippingStatus,
        cast(LineStatus as nvarchar(48)) as LineStatus,
        cast(FreightOutCOGS as decimal(19, 4)) as FreightOutCOGS,
        cast(ItemCOGS as decimal(19, 4)) as ItemCOGS,
        cast(HandlingFee as decimal(19, 4)) as HandlingFee,
        cast(DiscountAmount as decimal(19, 4)) as DiscountAmount,
        cast(RecordUpdatedAt as datetime) as RecordUpdatedAt,
        cast(Season as nvarchar(32)) as Season 
    from mdm
    union all
    select 
        cast(Number as nvarchar(200)) as Number,
        cast(ItemId as int) as ItemId,
        cast(TradingPartnerId as int) as TradingPartnerId,
        cast(Brand as nvarchar(200)) as Brand,
        cast(LastUpdatedAt as datetime) as LastUpdatedAt,
        cast(Amount as decimal(19, 4)) as Amount,
        cast(Quantity as int) as Quantity,
        cast(PONumber as nvarchar(64)) as PONumber,
        cast(PlacedDate as datetime) as PlacedDate,
        cast(CreatedDate as datetime) as CreatedDate,
        cast(ContractualShipDate as datetime) as ContractualShipDate,
        cast(PlannedShipDate as datetime) as PlannedShipDate,
        cast(ActualShipDate as datetime) as ActualShipDate,
        cast(HeaderCurrentStatus as nvarchar(48)) as HeaderCurrentStatus,
        cast(HeaderShippingStatus as nvarchar(48)) as HeaderShippingStatus,
        cast(LineStatus as nvarchar(48)) as LineStatus,
        cast(FreightOutCOGS as decimal(19, 4)) as FreightOutCOGS,
        cast(ItemCOGS as decimal(19, 4)) as ItemCOGS,
        cast(HandlingFee as decimal(19, 4)) as HandlingFee,
        cast(DiscountAmount as decimal(19, 4)) as DiscountAmount,
        cast(RecordUpdatedAt as datetime) as RecordUpdatedAt,
        cast(Season as nvarchar(32)) as Season 
    from returns_accruals
),

gross_to_net as (
    select
      u.*,
      case
        when u.Number like ''Birdies Shopify/%'' then .75
        when u.ItemId in (204260, 204261, 204262, 212170, 216852) then 1
        -- This is for Birdies 2024 budget which we do not have
        when u.Brand = ''Birdies'' 
          and act1.GrossToNetPercentage is null
          and act2.GrossToNetPercentage is null
          and act3.GrossToNetPercentage is null
          and act4.GrossToNetPercentage is null
          then 0.75
        -- This is for Discontinued brand budget which we do not have
        when u.Brand = ''Discontinued'' 
          and act1.GrossToNetPercentage is null
          and act2.GrossToNetPercentage is null
          and act3.GrossToNetPercentage is null
          and act4.GrossToNetPercentage is null
          then 0.8
        else coalesce(
          act1.GrossToNetPercentage, act2.GrossToNetPercentage, act3.GrossToNetPercentage, act4.GrossToNetPercentage,
          bud1.GrossToNetPercentage, bud2.GrossToNetPercentage, bud3.GrossToNetPercentage, bud4.GrossToNetPercentage
        )
      end as GrossToNetPercentage,
      case
        when u.Number like ''Birdies Shopify/%'' then ''Birdies_Historical''
        when u.ItemId in (204260, 204261, 204262, 212170, 216852) then ''Shipping_Protection''
        -- This is for Birdies 2024 budget which we do not have
        when u.Brand = ''Birdies'' 
          and act1.GrossToNetPercentage is null
          and act2.GrossToNetPercentage is null
          and act3.GrossToNetPercentage is null
          and act4.GrossToNetPercentage is null
          then ''Birdies_Budget''
        -- This is for Discontinued brand budget which we do not have
        when u.Brand = ''Discontinued'' 
          and act1.GrossToNetPercentage is null
          and act2.GrossToNetPercentage is null
          and act3.GrossToNetPercentage is null
          and act4.GrossToNetPercentage is null
          then ''Discontinued_Budget''
        when act1.GrossToNetPercentage is not null then ''Actuals_Subclass''
        when act2.GrossToNetPercentage is not null then ''Actuals_Subclass''
        when act3.GrossToNetPercentage is not null then ''Actuals_Class''
        when act4.GrossToNetPercentage is not null then ''Actuals_TradingPartner''
        when bud1.GrossToNetPercentage is not null then ''Budget_Subclass''
        when bud2.GrossToNetPercentage is not null then ''Budget_Class''
        when bud3.GrossToNetPercentage is not null then ''Budget_TradingPartner''
        when bud4.GrossToNetPercentage is not null then ''Budget_Brand''
        else null
      end as GrossToNetSource
    from unioned u
    join "KNSDataWarehouse"."Deposco"."DimItem" i
      on u.ItemId = i.ItemId
    left join actuals_subclass act1
      on u.TradingPartnerId = act1.TradingPartnerId
      and i.BrandId = act1.BrandId
      and i.Class = act1.Class
      and i.Subclass = act1.Subclass
      and eomonth(u.ActualShipDate) = act1.MonthEndAt
    left join actuals_subclass act2
      on u.TradingPartnerId = act2.TradingPartnerId
      and i.BrandId = act2.BrandId
      and i.Class = act2.Class
      and ''Casual,Mocc/Oxford-W'' = act2.Subclass
      and ''Casual,Shoes-W'' = i.Subclass
      and eomonth(u.ActualShipDate) = act1.MonthEndAt
    left join actuals_class act3
      on u.TradingPartnerId = act3.TradingPartnerId
      and i.BrandId = act3.BrandId
      and i.Class = act3.Class
      and eomonth(u.ActualShipDate) = act3.MonthEndAt
    left join actuals_tradingpartner act4
      on u.TradingPartnerId = act4.TradingPartnerId
      and i.BrandId = act4.BrandId
      and eomonth(u.ActualShipDate) = act4.MonthEndAt
    left join budget_subclass bud1
      on u.TradingPartnerId = bud1.TradingPartnerId
      and i.BrandId = bud1.BrandId
      and i.Class = bud1.Class
      and i.Subclass = bud1.Subclass
      and eomonth(u.ActualShipDate) = bud1.MonthEndDate
    left join budget_class bud2
      on u.TradingPartnerId = bud2.TradingPartnerId
      and i.BrandId = bud2.BrandId
      and i.Class = bud2.Class
      and eomonth(u.ActualShipDate) = bud2.MonthEndDate
    left join budget_tradingpartner bud3
      on u.TradingPartnerId = bud3.TradingPartnerId
      and i.BrandId = bud3.BrandId
      and eomonth(u.ActualShipDate) = bud3.MonthEndDate
    left join budget_brand bud4
      on i.BrandId = bud4.BrandId
      and eomonth(u.ActualShipDate) = bud4.MonthEndDate
),

final as (
    select
        *
    from gross_to_net
    where PlacedDate >= datefromparts(year(getdate()) - 2, 1, 1)
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactSalesLine__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactSalesLine__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactSalesLine__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactSalesLine__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactSalesLine__dbt_tmp')
    )
    DROP index "KNS"."FactSalesLine__dbt_tmp".KNS_FactSalesLine__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactSalesLine__dbt_tmp_cci
    ON "KNS"."FactSalesLine__dbt_tmp"

   


  