
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_f023bf423ea9d47c2621d52dc2f69a88]
   as 
    
    



select FinancialChannelType
from "KNSUnifiedMDM"."Orders"."TradingPartner"
where FinancialChannelType is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_f023bf423ea9d47c2621d52dc2f69a88]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_f023bf423ea9d47c2621d52dc2f69a88]
  ;')