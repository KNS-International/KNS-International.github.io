
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_1e8e57870b95364c3681aeae7e7e79f3]
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

    [dbt_test__audit.testview_1e8e57870b95364c3681aeae7e7e79f3]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_1e8e57870b95364c3681aeae7e7e79f3]
  ;')