
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_cb92675420d390ed0c484b502c4503c1]
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

    [dbt_test__audit.testview_cb92675420d390ed0c484b502c4503c1]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_cb92675420d390ed0c484b502c4503c1]
  ;')