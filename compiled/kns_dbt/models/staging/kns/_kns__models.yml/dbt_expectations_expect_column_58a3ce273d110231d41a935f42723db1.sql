with relation_columns as (

        
        select
            cast('NUMBER' as VARCHAR(8000)) as relation_column,
            cast('VARCHAR' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast('FREIGHTFORWARDER' as VARCHAR(8000)) as relation_column,
            cast('VARCHAR' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast('VESSELLOADEDAT' as VARCHAR(8000)) as relation_column,
            cast('DATE' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast('ESTIMATEDUSPORTAT' as VARCHAR(8000)) as relation_column,
            cast('DATE' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast('ESTIMATEDUSSTARTSHIPAT' as VARCHAR(8000)) as relation_column,
            cast('DATE' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast('ESTIMATEDARRIVALAT' as VARCHAR(8000)) as relation_column,
            cast('DATE' as VARCHAR(8000)) as relation_column_type
        
        
    ),
    test_data as (

        select
            *
        from
            relation_columns
        where
            relation_column = 'ESTIMATEDARRIVALAT'
            and
            relation_column_type not in ('DATE')

    )
    select *
    from test_data