
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_e8dfc2de6fc45ba5073ee07b8d09d429]
   as 
    
    



select TradingPartnerId
from "KNSDevDbt"."dbt_tlawson_marts"."dim_trading_partner"
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

    [dbt_test__audit.testview_e8dfc2de6fc45ba5073ee07b8d09d429]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_e8dfc2de6fc45ba5073ee07b8d09d429]
  ;')