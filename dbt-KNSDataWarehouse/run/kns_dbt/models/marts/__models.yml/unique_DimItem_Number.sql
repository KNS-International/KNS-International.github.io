
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_03566516e1fe38b219c515c99b4f8390]
   as 
    
    

select
    Number as unique_field,
    count(*) as n_records

from "KNSDataWarehouse"."Deposco"."DimItem"
where Number is not null
group by Number
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

    [dbt_test__audit.testview_03566516e1fe38b219c515c99b4f8390]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_03566516e1fe38b219c515c99b4f8390]
  ;')