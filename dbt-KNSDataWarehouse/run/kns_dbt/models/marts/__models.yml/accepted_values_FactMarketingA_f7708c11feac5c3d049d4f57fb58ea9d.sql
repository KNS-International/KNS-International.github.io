
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_90ae3b365a45162b47bfa7c4b848d4f8]
   as 
    
    

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
    ''Top Funnel / Awareness'',''Mid Funnel'',''Bottom Funnel / Conversions'',''Retargeting'',''Prospecting'',''Retention'',''NBSearch'',''BrandSearch'',''PMax'',''BrandShopping'',''NBShopping'',''Null''
)


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_90ae3b365a45162b47bfa7c4b848d4f8]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_90ae3b365a45162b47bfa7c4b848d4f8]
  ;')