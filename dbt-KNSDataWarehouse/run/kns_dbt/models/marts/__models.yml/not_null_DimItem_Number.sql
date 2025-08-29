
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_4ff16923e8cf0e2458eac1964f77fb8c]
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

    [dbt_test__audit.testview_4ff16923e8cf0e2458eac1964f77fb8c]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_4ff16923e8cf0e2458eac1964f77fb8c]
  ;')