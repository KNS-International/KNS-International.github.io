
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_87438f9f969a52ce09f6d3c60d2fad0d]
   as 
    
    



select id
from "KNSDevDbt"."dbt_tlawson"."my_second_dbt_model"
where id is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_87438f9f969a52ce09f6d3c60d2fad0d]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_87438f9f969a52ce09f6d3c60d2fad0d]
  ;')