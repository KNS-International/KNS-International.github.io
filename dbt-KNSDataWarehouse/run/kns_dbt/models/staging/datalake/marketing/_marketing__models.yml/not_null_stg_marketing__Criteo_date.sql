
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_1c6649c0ddfc5ef84b7a3f18e804a18e]
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

    [dbt_test__audit.testview_1c6649c0ddfc5ef84b7a3f18e804a18e]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_1c6649c0ddfc5ef84b7a3f18e804a18e]
  ;')