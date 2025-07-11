
  


with 

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
    where AccountNumber in ('4000', '4050', '4100', '4101', '4102', '4103', '4104', '4105', '4106')
),

final as (
    select * from filters
)

select * from final