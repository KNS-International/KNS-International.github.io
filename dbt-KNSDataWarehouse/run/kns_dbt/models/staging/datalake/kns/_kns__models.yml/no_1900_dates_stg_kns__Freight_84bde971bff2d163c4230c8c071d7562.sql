
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_b22a3332a1dc1872533e3f592c5f7f9e]
   as 
    select *
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__FreightForwarder_AirAndSea"
    where EstimatedUSPortAt = ''1900-01-01''
;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_b22a3332a1dc1872533e3f592c5f7f9e]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_b22a3332a1dc1872533e3f592c5f7f9e]
  ;')