
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_0ccd3ba2c1590152a634852c5463af18]
   as 
    
    



select Number
from "KNSDataWarehouse"."KNS"."FactSalesLine"
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

    [dbt_test__audit.testview_0ccd3ba2c1590152a634852c5463af18]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_0ccd3ba2c1590152a634852c5463af18]
  ;')