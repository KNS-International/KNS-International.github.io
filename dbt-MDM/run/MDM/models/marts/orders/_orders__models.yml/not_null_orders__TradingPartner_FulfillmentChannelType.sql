
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_15b363df9be6ca42560f048b02845cc0]
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

    [dbt_test__audit.testview_15b363df9be6ca42560f048b02845cc0]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_15b363df9be6ca42560f048b02845cc0]
  ;')