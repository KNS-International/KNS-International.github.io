
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_cd694e5b6ce6557507d1a4f9245df084]
   as 
    
    

select
    id as unique_field,
    count(*) as n_records

from "KNSDevDbt"."dbt_tlawson"."my_second_dbt_model"
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

    [dbt_test__audit.testview_cd694e5b6ce6557507d1a4f9245df084]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_cd694e5b6ce6557507d1a4f9245df084]
  ;')