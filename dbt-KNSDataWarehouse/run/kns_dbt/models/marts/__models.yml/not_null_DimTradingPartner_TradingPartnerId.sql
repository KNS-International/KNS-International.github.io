
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_086ecc3f2d11dfececa005f2efd3e95c]
   as 
    
    



select TradingPartnerId
from "KNSDataWarehouse"."Deposco"."DimTradingPartner"
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

    [dbt_test__audit.testview_086ecc3f2d11dfececa005f2efd3e95c]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_086ecc3f2d11dfececa005f2efd3e95c]
  ;')