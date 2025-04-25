
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_827deb139642e863b14d56d2c5a420ff]
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

    [dbt_test__audit.testview_827deb139642e863b14d56d2c5a420ff]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_827deb139642e863b14d56d2c5a420ff]
  ;')