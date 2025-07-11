
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_0d532368e8fce8d23152011f608d4ee6]
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

    [dbt_test__audit.testview_0d532368e8fce8d23152011f608d4ee6]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_0d532368e8fce8d23152011f608d4ee6]
  ;')