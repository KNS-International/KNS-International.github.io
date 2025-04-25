
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_f96aee9fc9a4b918cc92ba3e70b8adb1]
   as 
    
    



select date
from "KNSDevDbt"."dbt_tlawson_staging"."stg_marketing__Criteo"
where date is null


;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_f96aee9fc9a4b918cc92ba3e70b8adb1]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_f96aee9fc9a4b918cc92ba3e70b8adb1]
  ;')