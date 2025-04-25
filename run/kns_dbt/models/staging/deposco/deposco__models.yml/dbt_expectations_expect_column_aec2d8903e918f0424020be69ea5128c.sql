
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_085e825eeae9c571fa38b2ed89b1971e]
   as with relation_columns as (

        
        select
            cast(''PACKID'' as VARCHAR(8000)) as relation_column,
            cast(''BIGINT'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''QUANTITY'' as VARCHAR(8000)) as relation_column,
            cast(''INT'' as VARCHAR(8000)) as relation_column_type
        
        
    ),
    test_data as (

        select
            *
        from
            relation_columns
        where
            relation_column = ''QUANTITY''
            and
            relation_column_type not in (''DATE'')

    )
    select *
    from test_data;')
  select
    count(*) as failures,
    case when count(*) != 0
      then 'true' else 'false' end as should_warn,
    case when count(*) != 0
      then 'true' else 'false' end as should_error
  from (
    select  * from 

    [dbt_test__audit.testview_085e825eeae9c571fa38b2ed89b1971e]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_085e825eeae9c571fa38b2ed89b1971e]
  ;')