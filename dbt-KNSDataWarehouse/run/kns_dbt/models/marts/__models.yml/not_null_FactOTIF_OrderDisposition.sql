
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_452fda16fa1e4690dc56e7217a846c64]
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

    [dbt_test__audit.testview_452fda16fa1e4690dc56e7217a846c64]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_452fda16fa1e4690dc56e7217a846c64]
  ;')