
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_f7c415aff2f71c40c53d13aca91224f4]
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

    [dbt_test__audit.testview_f7c415aff2f71c40c53d13aca91224f4]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_f7c415aff2f71c40c53d13aca91224f4]
  ;')