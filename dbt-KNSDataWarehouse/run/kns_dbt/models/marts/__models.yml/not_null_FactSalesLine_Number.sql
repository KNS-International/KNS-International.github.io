
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_6b6bb462a2b39787d6e72e7a69affecc]
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

    [dbt_test__audit.testview_6b6bb462a2b39787d6e72e7a69affecc]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_6b6bb462a2b39787d6e72e7a69affecc]
  ;')