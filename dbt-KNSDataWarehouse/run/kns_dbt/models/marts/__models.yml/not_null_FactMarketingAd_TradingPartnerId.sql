
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_43f7100d22142d24d893c80c79b218ca]
   as 
    
    



select TradingPartnerId
from "KNSDevDbt"."dbt_prod_marts"."FactMarketingAd"
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

    [dbt_test__audit.testview_43f7100d22142d24d893c80c79b218ca]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_43f7100d22142d24d893c80c79b218ca]
  ;')