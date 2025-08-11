
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_493d923a8b4b393a5f32980ebe3e7b4e]
   as 
    
    

select
    FactSalesLineNumber as unique_field,
    count(*) as n_records

from "KNSDataWarehouse"."Deposco"."DimPLD"
where FactSalesLineNumber is not null
group by FactSalesLineNumber
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

    [dbt_test__audit.testview_493d923a8b4b393a5f32980ebe3e7b4e]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_493d923a8b4b393a5f32980ebe3e7b4e]
  ;')