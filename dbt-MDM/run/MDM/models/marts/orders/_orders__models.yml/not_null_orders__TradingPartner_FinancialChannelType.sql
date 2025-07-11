
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_1a83da65cb63ead4764e276bbdb7e1fa]
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

    [dbt_test__audit.testview_1a83da65cb63ead4764e276bbdb7e1fa]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_1a83da65cb63ead4764e276bbdb7e1fa]
  ;')