
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_8cf34e2120560f5a6c1752e8a002b839]
   as 
    
    

select
    TradingPartnerId as unique_field,
    count(*) as n_records

from "KNSDevDbt"."dbt_prod_marts"."DimTradingPartner"
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

    [dbt_test__audit.testview_8cf34e2120560f5a6c1752e8a002b839]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_8cf34e2120560f5a6c1752e8a002b839]
  ;')