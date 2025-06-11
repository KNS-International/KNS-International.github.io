
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_60a14e212e3055b1a79b8a41c4c94f11]
   as 
    
    



select StyleId
from "KNSUnifiedMDM"."Products"."Variant"
where StyleId is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_60a14e212e3055b1a79b8a41c4c94f11]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_60a14e212e3055b1a79b8a41c4c94f11]
  ;')