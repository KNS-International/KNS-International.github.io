
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_47eab3504c4ea18c58a623c892d6c669]
   as 
    
    

select
    id as unique_field,
    count(*) as n_records

from "KNSDevDbt"."dbt_tlawson"."my_first_dbt_model"
where id is not null
group by id
having count(*) > 1


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_47eab3504c4ea18c58a623c892d6c669]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_47eab3504c4ea18c58a623c892d6c669]
  ;')