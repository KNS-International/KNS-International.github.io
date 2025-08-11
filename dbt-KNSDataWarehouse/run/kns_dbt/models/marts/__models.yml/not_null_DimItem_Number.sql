
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_d6f0df2a8d2cd5918c798db5787433cd]
   as 
    
    



select Number
from "KNSDataWarehouse"."Deposco"."DimItem"
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

    [dbt_test__audit.testview_d6f0df2a8d2cd5918c798db5787433cd]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_d6f0df2a8d2cd5918c798db5787433cd]
  ;')