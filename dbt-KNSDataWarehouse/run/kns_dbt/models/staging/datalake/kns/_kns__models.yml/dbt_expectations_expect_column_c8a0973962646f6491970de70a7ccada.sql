
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_23b1799c29c110dcae571f5f20fe1b06]
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

    [dbt_test__audit.testview_23b1799c29c110dcae571f5f20fe1b06]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_23b1799c29c110dcae571f5f20fe1b06]
  ;')