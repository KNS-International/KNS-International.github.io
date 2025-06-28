
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_e2bc7bb3f84ec3b0b1b657c4507c2c54]
   as 
    
    



select OrderDisposition
from "KNSDataWarehouse"."KNS"."FactOTIF"
where OrderDisposition is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_e2bc7bb3f84ec3b0b1b657c4507c2c54]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_e2bc7bb3f84ec3b0b1b657c4507c2c54]
  ;')