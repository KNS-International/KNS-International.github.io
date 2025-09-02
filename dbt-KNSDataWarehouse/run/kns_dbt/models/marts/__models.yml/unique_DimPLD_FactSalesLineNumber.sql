
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_bc79b349a0e536a27f68c359fb315c9e]
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

    [dbt_test__audit.testview_bc79b349a0e536a27f68c359fb315c9e]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_bc79b349a0e536a27f68c359fb315c9e]
  ;')