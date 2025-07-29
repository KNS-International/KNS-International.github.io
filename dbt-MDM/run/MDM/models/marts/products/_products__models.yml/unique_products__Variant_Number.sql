
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_8d79cf89e058dca4e238916f70f3aaff]
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

    [dbt_test__audit.testview_8d79cf89e058dca4e238916f70f3aaff]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_8d79cf89e058dca4e238916f70f3aaff]
  ;')