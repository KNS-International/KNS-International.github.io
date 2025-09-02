
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_e2ac62be5802388ff4b8685c9b51eb39]
   as 
    
    



select FactSalesLineNumber
from "KNSDataWarehouse"."Deposco"."DimPLD"
where FactSalesLineNumber is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_e2ac62be5802388ff4b8685c9b51eb39]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_e2ac62be5802388ff4b8685c9b51eb39]
  ;')