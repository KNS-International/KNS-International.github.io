
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_b0cbcb6bfb2d345b3791904c931fcd0c]
   as 
    
    



select TradingPartnerId
from "KNSDataWarehouse"."KNS"."FactMarketingAd"
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

    [dbt_test__audit.testview_b0cbcb6bfb2d345b3791904c931fcd0c]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_b0cbcb6bfb2d345b3791904c931fcd0c]
  ;')