
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_c9d0e0f52ca7cdfb91fe547bb4a5deeb]
   as 
    select *
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__FreightForwarder_AirAndSea"
    where EstimatedArrivalAt = ''1900-01-01''
;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_c9d0e0f52ca7cdfb91fe547bb4a5deeb]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_c9d0e0f52ca7cdfb91fe547bb4a5deeb]
  ;')