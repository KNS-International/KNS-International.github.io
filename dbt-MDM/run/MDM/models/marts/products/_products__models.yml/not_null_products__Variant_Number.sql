
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_8b0c68615c9c9858196ae3c953f1a799]
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

    [dbt_test__audit.testview_8b0c68615c9c9858196ae3c953f1a799]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_8b0c68615c9c9858196ae3c953f1a799]
  ;')