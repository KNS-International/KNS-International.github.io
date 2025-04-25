
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_a133e9551111e8e09d849e262d29aa26]
   as 
    
    



select TradingPartnerId
from "KNSDevDbt"."dbt_tlawson_intermediate"."int_marketing__SourcesMapped"
where TradingPartnerId is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_a133e9551111e8e09d849e262d29aa26]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_a133e9551111e8e09d849e262d29aa26]
  ;')