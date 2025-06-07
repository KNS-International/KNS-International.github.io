
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_ab468a6b7af8ce25bc1fd5e5a26e1cbd]
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

    [dbt_test__audit.testview_ab468a6b7af8ce25bc1fd5e5a26e1cbd]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_ab468a6b7af8ce25bc1fd5e5a26e1cbd]
  ;')