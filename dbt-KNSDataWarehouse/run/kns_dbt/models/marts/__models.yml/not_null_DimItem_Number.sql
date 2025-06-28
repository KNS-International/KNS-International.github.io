
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_337f14405d0d5886dc53d9c1a03b9186]
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

    [dbt_test__audit.testview_337f14405d0d5886dc53d9c1a03b9186]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_337f14405d0d5886dc53d9c1a03b9186]
  ;')