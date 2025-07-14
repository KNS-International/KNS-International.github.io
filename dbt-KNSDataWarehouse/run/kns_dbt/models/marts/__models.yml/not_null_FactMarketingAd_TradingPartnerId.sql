
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_dc802d0a6231f21169489c56febdb18d]
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

    [dbt_test__audit.testview_dc802d0a6231f21169489c56febdb18d]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_dc802d0a6231f21169489c56febdb18d]
  ;')