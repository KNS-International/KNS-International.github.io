
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_c0b6c6823b298da82c8f7f4c93757b57]
   as 
    
    



select date
from "KNSDevDbt"."dbt_prod_staging"."stg_marketing__Criteo"
where date is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_c0b6c6823b298da82c8f7f4c93757b57]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_c0b6c6823b298da82c8f7f4c93757b57]
  ;')