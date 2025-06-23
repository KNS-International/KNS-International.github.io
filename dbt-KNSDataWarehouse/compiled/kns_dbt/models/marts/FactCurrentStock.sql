
  


with

current_stock as (
    select cs.* 
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__CurrentStock" cs
    join "KNSDataWarehouse"."Deposco"."DimItem" i on cs.ItemId = i.ItemId
)

select * from current_stock