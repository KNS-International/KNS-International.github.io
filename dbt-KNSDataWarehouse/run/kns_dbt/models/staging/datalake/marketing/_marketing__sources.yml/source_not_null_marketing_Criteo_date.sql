
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_c07af531a2f17db18f2a1ed63c286938]
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

    [dbt_test__audit.testview_c07af531a2f17db18f2a1ed63c286938]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_c07af531a2f17db18f2a1ed63c286938]
  ;')