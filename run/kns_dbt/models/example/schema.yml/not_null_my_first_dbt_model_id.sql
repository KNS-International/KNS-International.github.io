
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_42c83e21e2b845706e1879973852ce53]
   as 
    
    



select id
from "KNSDevDbt"."dbt_tlawson"."my_first_dbt_model"
where id is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_42c83e21e2b845706e1879973852ce53]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_42c83e21e2b845706e1879973852ce53]
  ;')