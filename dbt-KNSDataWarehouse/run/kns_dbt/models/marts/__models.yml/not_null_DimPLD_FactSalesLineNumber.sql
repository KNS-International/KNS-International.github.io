
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_6f70d6c0b9387ce12c1770e94bea0718]
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

    [dbt_test__audit.testview_6f70d6c0b9387ce12c1770e94bea0718]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_6f70d6c0b9387ce12c1770e94bea0718]
  ;')