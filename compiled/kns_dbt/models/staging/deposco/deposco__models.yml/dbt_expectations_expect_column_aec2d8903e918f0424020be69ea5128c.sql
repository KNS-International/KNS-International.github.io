with relation_columns as (

        
        select
            cast('PACKID' as VARCHAR(8000)) as relation_column,
            cast('BIGINT' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast('QUANTITY' as VARCHAR(8000)) as relation_column,
            cast('INT' as VARCHAR(8000)) as relation_column_type
        
        
    ),
    test_data as (

        select
            *
        from
            relation_columns
        where
            relation_column = 'QUANTITY'
            and
            relation_column_type not in ('DATE')

    )
    select *
    from test_data