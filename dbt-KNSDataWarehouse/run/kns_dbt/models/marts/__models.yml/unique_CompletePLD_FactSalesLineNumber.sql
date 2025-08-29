
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_a0993a2433fc873dc55aa8b1586ae886]
   as 
    
    

select
    FactSalesLineNumber as unique_field,
    count(*) as n_records

from "KNSDataWarehouse"."KNS"."CompletePLD"
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

    [dbt_test__audit.testview_a0993a2433fc873dc55aa8b1586ae886]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_a0993a2433fc873dc55aa8b1586ae886]
  ;')