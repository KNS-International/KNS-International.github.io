
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_c75a06c23518b3b5e433711a934cb68f]
   as 
    
    



select TradingPartnerId
from "KNSDevDbt"."dbt_prod_marts"."DimTradingPartner"
where TradingPartnerId is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_c75a06c23518b3b5e433711a934cb68f]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_c75a06c23518b3b5e433711a934cb68f]
  ;')