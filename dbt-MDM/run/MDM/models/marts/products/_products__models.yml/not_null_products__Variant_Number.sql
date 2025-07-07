
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_9a26a932f8a0877e5d32adb3d3d961ec]
   as 
    
    



select Number
from "KNSUnifiedMDM"."Products"."Variant"
where Number is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_9a26a932f8a0877e5d32adb3d3d961ec]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_9a26a932f8a0877e5d32adb3d3d961ec]
  ;')