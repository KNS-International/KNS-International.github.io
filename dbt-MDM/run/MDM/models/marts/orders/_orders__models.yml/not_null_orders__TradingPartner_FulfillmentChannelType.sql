
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_6877993ebe35ad31f1ec66b9393b12e2]
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

    [dbt_test__audit.testview_6877993ebe35ad31f1ec66b9393b12e2]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_6877993ebe35ad31f1ec66b9393b12e2]
  ;')