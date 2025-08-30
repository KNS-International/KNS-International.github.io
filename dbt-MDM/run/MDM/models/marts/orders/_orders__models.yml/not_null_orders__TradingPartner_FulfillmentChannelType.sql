
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_07baff976e9d7452e008c71ad4e76777]
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

    [dbt_test__audit.testview_07baff976e9d7452e008c71ad4e76777]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_07baff976e9d7452e008c71ad4e76777]
  ;')