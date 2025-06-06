
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_74f2ed2182032e404fd62053d9c2ae71]
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

    [dbt_test__audit.testview_74f2ed2182032e404fd62053d9c2ae71]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_74f2ed2182032e404fd62053d9c2ae71]
  ;')