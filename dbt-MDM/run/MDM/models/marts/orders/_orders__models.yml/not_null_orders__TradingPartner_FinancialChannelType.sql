
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_16d4a27684af064a2a4b38e3e9d5d060]
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

    [dbt_test__audit.testview_16d4a27684af064a2a4b38e3e9d5d060]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_16d4a27684af064a2a4b38e3e9d5d060]
  ;')