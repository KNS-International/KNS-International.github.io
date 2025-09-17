
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_1bd314f1bd2743456b83ece34ff4909a]
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

    [dbt_test__audit.testview_1bd314f1bd2743456b83ece34ff4909a]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_1bd314f1bd2743456b83ece34ff4909a]
  ;')