
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_47ad985c21d2e020e6e117aa96ce16b7]
   as 
    
    



select FulfillmentChannelType
from "KNSUnifiedMDM"."Orders"."TradingPartner"
where FulfillmentChannelType is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_47ad985c21d2e020e6e117aa96ce16b7]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_47ad985c21d2e020e6e117aa96ce16b7]
  ;')