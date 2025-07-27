
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_53182b32c4a5a7e1ae914b1d8c3853d9]
   as 
    
    



select Number
from "KNSDataWarehouse"."Deposco"."DimItem"
where Number is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_53182b32c4a5a7e1ae914b1d8c3853d9]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_53182b32c4a5a7e1ae914b1d8c3853d9]
  ;')