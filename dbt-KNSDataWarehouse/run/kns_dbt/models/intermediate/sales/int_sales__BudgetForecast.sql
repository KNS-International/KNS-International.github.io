USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_intermediate"."int_sales__BudgetForecast__dbt_tmp" as with 

filters as (
    select
        Identifier,
        AccountNumber,
        AccountName,
        BrandId,
        Class,
        Subclass,
        TradingPartnerId,
        MonthEndDate,
        Amount
    from "KNSDevDbt"."dbt_prod_staging"."stg_orders__BudgetForecast"
    where AccountNumber in (''4000'', ''4050'', ''4100'', ''4101'', ''4102'', 
                            ''4103'', ''4104'', ''4105'', ''4106'', ''5000'', 
                            ''5100'', ''5200'', ''6070'', ''6067'', ''6035'',
                            ''6021'', ''6045'', ''6056'')
    or AccountName = ''Units''
),

new_columns as (
    select
        Identifier,
        AccountNumber,
        AccountName,
        BrandId,
        Class,
        Subclass,
        TradingPartnerId,
        MonthEndDate,
        Amount,
        iif(AccountNumber in (''4000'', ''4050''), 1, 0) as IsGrossSales,
        iif(AccountNumber in (''4100'', ''4101'', ''4102'', ''4103'', ''4104'', ''4105'', ''4106''), 1, 0) as IsNetAdj,
        iif(AccountNumber = ''5000'', 1, 0) as IsProductCogs,
        iif(AccountNumber = ''5100'', 1, 0) as IsFreightOut,
        iif(AccountNumber = ''5200'', 1, 0) as IsFreightIn
    from filters
    where Amount != 0
),

numbers as (
    select TOP (31) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 as n
    from master..spt_values
),

expanded as (
    select
        nc.Identifier,
        nc.AccountNumber,
        nc.AccountName,
        nc.BrandId,
        nc.Class,
        nc.Subclass,
        nc.TradingPartnerId,
        nc.MonthEndDate,
        DATEADD(day, n.n, DATEFROMPARTS(YEAR(nc.MonthEndDate), MONTH(nc.MonthEndDate), 1)) as DailyDate,
        nc.Amount,
        round(nc.Amount / (DAY(EOMONTH(nc.MonthEndDate))), 4) as DailyAmount,
        nc.IsGrossSales,
        nc.IsNetAdj,
        nc.IsProductCogs,
        nc.IsFreightOut,
        nc.IsFreightIn
    from new_columns nc
    join numbers n
        on n.n < DAY(EOMONTH(nc.MonthEndDate))
)

select * from expanded;
    ')

