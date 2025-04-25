
  
  

  
  USE [KNSDevDbt];
  EXEC('create view 

    [dbt_test__audit.testview_c403ca3d03f40e25994019ca3de5a416]
   as with relation_columns as (

        
        select
            cast(''NO'' as VARCHAR(8000)) as relation_column,
            cast(''TINYINT'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''INTERNAL REMARKS'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''HB/L NO.'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''CONTAINER NO.'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''LFD'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''STAGES'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''SHIPMENT STATUS'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''SHIPPER'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''CONSIGNEE'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ETD'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ATD'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ETA'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ATA'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''PLACE OF DELIVERY ETA'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ETA DOOR'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''ATA DOOR'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''GATE OUT'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''EMPTY RETURN'' as VARCHAR(8000)) as relation_column,
            cast(''DATETIME2'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''POL'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''POD'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''DEL'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        union all
        
        select
            cast(''FINAL DESTINATION'' as VARCHAR(8000)) as relation_column,
            cast(''NVARCHAR'' as VARCHAR(8000)) as relation_column_type
        
        
    ),
    test_data as (

        select
            *
        from
            relation_columns
        where
            relation_column = ''PLACE OF DELIVERY ETA''
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

    [dbt_test__audit.testview_c403ca3d03f40e25994019ca3de5a416]
  
  ) dbt_internal_test;

  USE [KNSDevDbt];
  EXEC('drop view 

    [dbt_test__audit.testview_c403ca3d03f40e25994019ca3de5a416]
  ;')