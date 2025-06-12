
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_100ab7d2041621f9cd400e60b9da7a9d]
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

    [dbt_test__audit.testview_100ab7d2041621f9cd400e60b9da7a9d]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_100ab7d2041621f9cd400e60b9da7a9d]
  ;')