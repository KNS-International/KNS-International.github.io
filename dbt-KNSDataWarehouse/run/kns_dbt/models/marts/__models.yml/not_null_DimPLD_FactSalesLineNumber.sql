
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_e3e423cb297aebfe2766cd33d21b4bda]
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

    [dbt_test__audit.testview_e3e423cb297aebfe2766cd33d21b4bda]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_e3e423cb297aebfe2766cd33d21b4bda]
  ;')