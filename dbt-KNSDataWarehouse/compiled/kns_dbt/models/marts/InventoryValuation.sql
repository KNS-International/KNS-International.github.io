
  


with

final as (
    select 
        *
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__InventoryValuation"
)

select * from final