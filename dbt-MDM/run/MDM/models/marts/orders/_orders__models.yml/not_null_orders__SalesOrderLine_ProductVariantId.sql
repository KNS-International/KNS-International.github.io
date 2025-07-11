
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_60204d6fd2925d30b673e2e070a24ce8]
   as 
    
    



select ProductVariantId
from "KNSUnifiedMDM"."Orders"."SalesOrderLine"
where ProductVariantId is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_60204d6fd2925d30b673e2e070a24ce8]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_60204d6fd2925d30b673e2e070a24ce8]
  ;')