
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_a142ace507f1e21af66c10c9be4e2c6b]
   as 
    
    

select
    TradingPartnerId as unique_field,
    count(*) as n_records

from "KNSDataWarehouse"."Deposco"."DimTradingPartner"
where TradingPartnerId is not null
group by TradingPartnerId
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

    [dbt_test__audit.testview_a142ace507f1e21af66c10c9be4e2c6b]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_a142ace507f1e21af66c10c9be4e2c6b]
  ;')