
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_ea86a2034ad18a82cf27555dd505916a]
   as 
    
    



select TradingPartnerId
from "KNSDataWarehouse"."KNS"."FactMarketingAd"
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

    [dbt_test__audit.testview_ea86a2034ad18a82cf27555dd505916a]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_ea86a2034ad18a82cf27555dd505916a]
  ;')