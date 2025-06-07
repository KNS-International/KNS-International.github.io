
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_bb37268f1fe2804e982aaacb67a7c4f6]
   as 
    
    



select TradingPartnerId
from "KNSDevDbt"."dbt_prod_marts"."DimTradingPartner"
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

    [dbt_test__audit.testview_bb37268f1fe2804e982aaacb67a7c4f6]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_bb37268f1fe2804e982aaacb67a7c4f6]
  ;')