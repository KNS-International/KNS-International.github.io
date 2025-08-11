
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_f498eae58139fc178deb0a67cd977b16]
   as 
    select *
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__FreightForwarder_DSV"
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

    [dbt_test__audit.testview_f498eae58139fc178deb0a67cd977b16]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_f498eae58139fc178deb0a67cd977b16]
  ;')