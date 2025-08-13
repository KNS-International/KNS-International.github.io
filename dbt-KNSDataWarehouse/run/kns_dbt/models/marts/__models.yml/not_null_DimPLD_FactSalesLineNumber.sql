
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_7ad2470a953951fa31eacecd462ee011]
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

    [dbt_test__audit.testview_7ad2470a953951fa31eacecd462ee011]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_7ad2470a953951fa31eacecd462ee011]
  ;')