
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_a3b478f9efc56b8b4f3a174f4ff1e41a]
   as with relation_columns as (

        
        select
            cast(''NUMBER'' as VARCHAR(8000)) as relation_column,
            cast(''VARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''FREIGHTFORWARDER'' as VARCHAR(8000)) as relation_column,
            cast(''VARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''VESSELLOADEDAT'' as VARCHAR(8000)) as relation_column,
            cast(''DATE'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ESTIMATEDUSPORTAT'' as VARCHAR(8000)) as relation_column,
            cast(''DATE'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ESTIMATEDUSSTARTSHIPAT'' as VARCHAR(8000)) as relation_column,
            cast(''DATE'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ESTIMATEDARRIVALAT'' as VARCHAR(8000)) as relation_column,
            cast(''DATE'' as VARCHAR(8000)) as relation_column_type
        
        
    ),
    test_data as (

        select
            *
        from
            relation_columns
        where
            relation_column = ''ESTIMATEDUSPORTAT''
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

    [dbt_test__audit.testview_a3b478f9efc56b8b4f3a174f4ff1e41a]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_a3b478f9efc56b8b4f3a174f4ff1e41a]
  ;')