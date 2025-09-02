
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_471179b2ac562f9527c4117e6f7ca1bb]
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

    [dbt_test__audit.testview_471179b2ac562f9527c4117e6f7ca1bb]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_471179b2ac562f9527c4117e6f7ca1bb]
  ;')