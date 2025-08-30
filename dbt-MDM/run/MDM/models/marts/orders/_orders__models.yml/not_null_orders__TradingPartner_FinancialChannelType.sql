
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_83df55048b63079b8b7b2554ba2c396e]
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

    [dbt_test__audit.testview_83df55048b63079b8b7b2554ba2c396e]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_83df55048b63079b8b7b2554ba2c396e]
  ;')