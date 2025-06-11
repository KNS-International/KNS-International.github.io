
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_f1ff2cb636590c5d2750ec187d78222c]
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

    [dbt_test__audit.testview_f1ff2cb636590c5d2750ec187d78222c]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_f1ff2cb636590c5d2750ec187d78222c]
  ;')