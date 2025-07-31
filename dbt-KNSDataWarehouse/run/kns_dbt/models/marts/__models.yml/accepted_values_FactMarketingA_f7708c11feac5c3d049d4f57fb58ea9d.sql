
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_84ae1d02410211ce70663d5fd150e029]
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

    [dbt_test__audit.testview_84ae1d02410211ce70663d5fd150e029]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_84ae1d02410211ce70663d5fd150e029]
  ;')