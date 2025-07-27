
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_b03c9e0c721c811fc1758e752705d9ae]
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

    [dbt_test__audit.testview_b03c9e0c721c811fc1758e752705d9ae]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_b03c9e0c721c811fc1758e752705d9ae]
  ;')