
    
    

with all_values as (

    select
        Objective as value_field,
        count(*) as n_records

    from "KNSDevDbt"."dbt_prod_marts"."FactMarketingAd"
    group by Objective

)

select *
from all_values
where value_field not in (
    'Top Funnel / Awareness','Mid Funnel','Bottom Funnel / Conversions','Retargeting','Prospecting','Retention','NBSearch','BrandSearch','PMax','BrandShopping','NBShopping','Null'
)


