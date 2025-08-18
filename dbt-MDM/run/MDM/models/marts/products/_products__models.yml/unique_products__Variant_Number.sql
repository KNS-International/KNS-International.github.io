
  
  

  
  USE [KNSUnifiedMDM];
  EXEC('create view 

    [dbt_test__audit.testview_a5b3ddc9f99ed5a67075b55165791d28]
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

    [dbt_test__audit.testview_a5b3ddc9f99ed5a67075b55165791d28]
  
  ) dbt_internal_test;

  USE [KNSUnifiedMDM];
  EXEC('drop view 

    [dbt_test__audit.testview_a5b3ddc9f99ed5a67075b55165791d28]
  ;')