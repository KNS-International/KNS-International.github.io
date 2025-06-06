
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_652a5ae450d4989a09308c0b7b78b02c]
   as 
    
    



select date
from "KNSDataLake"."marketing"."Criteo"
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

    [dbt_test__audit.testview_652a5ae450d4989a09308c0b7b78b02c]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_652a5ae450d4989a09308c0b7b78b02c]
  ;')