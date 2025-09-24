
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_cab8f6f1b1d68440bb94dc51b2779ce9]
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

    [dbt_test__audit.testview_cab8f6f1b1d68440bb94dc51b2779ce9]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_cab8f6f1b1d68440bb94dc51b2779ce9]
  ;')