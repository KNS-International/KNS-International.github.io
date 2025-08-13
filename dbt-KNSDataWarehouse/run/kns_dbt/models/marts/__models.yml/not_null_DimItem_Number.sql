
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_2f69197e9c7473c0e4449c613733920f]
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

    [dbt_test__audit.testview_2f69197e9c7473c0e4449c613733920f]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_2f69197e9c7473c0e4449c613733920f]
  ;')