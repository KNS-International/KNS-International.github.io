
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_78820ff5e894c4a89463baee272c4060]
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

    [dbt_test__audit.testview_78820ff5e894c4a89463baee272c4060]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_78820ff5e894c4a89463baee272c4060]
  ;')