with

current_stock as (
    select * from "KNSDevDbt"."dbt_tlawson_intermediate"."int_sales__CurrentStock"
)

select * from current_stock