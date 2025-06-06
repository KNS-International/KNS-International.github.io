
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_016a1fbb0223aad632017d0045868f57]
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

    [dbt_test__audit.testview_016a1fbb0223aad632017d0045868f57]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_016a1fbb0223aad632017d0045868f57]
  ;')