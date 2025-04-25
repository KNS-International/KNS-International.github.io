
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_27f1e7bffc913b0957e8282c5fefa66e]
   as 
    
    



select TradingPartnerId
from "KNSDevDbt"."dbt_tlawson_marts"."DimTradingPartner"
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

    [dbt_test__audit.testview_27f1e7bffc913b0957e8282c5fefa66e]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_27f1e7bffc913b0957e8282c5fefa66e]
  ;')