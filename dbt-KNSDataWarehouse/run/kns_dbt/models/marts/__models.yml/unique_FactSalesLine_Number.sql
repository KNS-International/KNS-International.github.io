
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_3c68e25a73855028eef05fa18b457d80]
   as 
    
    

select
    Number as unique_field,
    count(*) as n_records

from "KNSDataWarehouse"."KNS"."FactSalesLine"
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

    [dbt_test__audit.testview_3c68e25a73855028eef05fa18b457d80]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_3c68e25a73855028eef05fa18b457d80]
  ;')