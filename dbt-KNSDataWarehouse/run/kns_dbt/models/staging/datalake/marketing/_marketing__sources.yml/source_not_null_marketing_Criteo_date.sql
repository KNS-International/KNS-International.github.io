
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_7aa4c1cf3b193bccedb39ff394da8f30]
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

    [dbt_test__audit.testview_7aa4c1cf3b193bccedb39ff394da8f30]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_7aa4c1cf3b193bccedb39ff394da8f30]
  ;')