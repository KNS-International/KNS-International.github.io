
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_9a2cab29ebebfe123d920766d75230a2]
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

    [dbt_test__audit.testview_9a2cab29ebebfe123d920766d75230a2]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_9a2cab29ebebfe123d920766d75230a2]
  ;')