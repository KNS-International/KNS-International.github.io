
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_230fc043a28accf846c24f4e8959fd11]
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

    [dbt_test__audit.testview_230fc043a28accf846c24f4e8959fd11]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_230fc043a28accf846c24f4e8959fd11]
  ;')