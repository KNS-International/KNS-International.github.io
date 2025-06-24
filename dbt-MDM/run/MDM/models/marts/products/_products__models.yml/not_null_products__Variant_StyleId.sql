
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_74227bd97549e132b26d9f044c1738e9]
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

    [dbt_test__audit.testview_74227bd97549e132b26d9f044c1738e9]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_74227bd97549e132b26d9f044c1738e9]
  ;')