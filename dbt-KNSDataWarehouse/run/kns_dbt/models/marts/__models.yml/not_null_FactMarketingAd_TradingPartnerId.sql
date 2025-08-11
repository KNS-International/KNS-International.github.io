
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_346b7678b8eafe626b2766175d9b0076]
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

    [dbt_test__audit.testview_346b7678b8eafe626b2766175d9b0076]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_346b7678b8eafe626b2766175d9b0076]
  ;')