with

current_stock as (
    select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__CurrentStock"
)

select * from current_stock