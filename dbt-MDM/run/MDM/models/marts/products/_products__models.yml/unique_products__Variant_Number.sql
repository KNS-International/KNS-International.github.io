
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_c6aa481f30cba06469e44daeac89bf14]
   as 
    
    

select
    Number as unique_field,
    count(*) as n_records

from "KNSUnifiedMDM"."Products"."Variant"
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

    [dbt_test__audit.testview_c6aa481f30cba06469e44daeac89bf14]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_c6aa481f30cba06469e44daeac89bf14]
  ;')