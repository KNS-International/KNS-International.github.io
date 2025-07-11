
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_bc8a4652c47abc8af2cc94444326e0b9]
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

    [dbt_test__audit.testview_bc8a4652c47abc8af2cc94444326e0b9]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_bc8a4652c47abc8af2cc94444326e0b9]
  ;')