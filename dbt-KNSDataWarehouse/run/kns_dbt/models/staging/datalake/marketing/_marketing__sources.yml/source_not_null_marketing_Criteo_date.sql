
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_43cd93c468d9e44e0ee0e44c97ab61e4]
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

    [dbt_test__audit.testview_43cd93c468d9e44e0ee0e44c97ab61e4]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_43cd93c468d9e44e0ee0e44c97ab61e4]
  ;')