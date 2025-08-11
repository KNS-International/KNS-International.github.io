
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_f5ead56e82b8b1b0983919e7fe72f48a]
   as 
    select *
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__FreightForwarder_SFI"
    where VesselLoadedAt = ''1900-01-01''
;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_f5ead56e82b8b1b0983919e7fe72f48a]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_f5ead56e82b8b1b0983919e7fe72f48a]
  ;')