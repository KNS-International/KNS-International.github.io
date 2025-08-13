
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_d624f0f520f8bde072390dddb967f78d]
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

    [dbt_test__audit.testview_d624f0f520f8bde072390dddb967f78d]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_d624f0f520f8bde072390dddb967f78d]
  ;')