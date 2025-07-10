
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_3405498e654264f23396c486084a4028]
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

    [dbt_test__audit.testview_3405498e654264f23396c486084a4028]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_3405498e654264f23396c486084a4028]
  ;')