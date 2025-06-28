
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_c69b9fa936955b71a6b021b2980b0b75]
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

    [dbt_test__audit.testview_c69b9fa936955b71a6b021b2980b0b75]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_c69b9fa936955b71a6b021b2980b0b75]
  ;')