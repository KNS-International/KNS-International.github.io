
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_e89ea8c0eb03191a70edc53ade044f03]
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

    [dbt_test__audit.testview_e89ea8c0eb03191a70edc53ade044f03]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_e89ea8c0eb03191a70edc53ade044f03]
  ;')