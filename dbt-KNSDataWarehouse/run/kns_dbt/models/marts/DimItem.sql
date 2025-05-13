
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_marts"."DimItem__dbt_tmp__dbt_tmp_vw" as with

dim_item as (
    select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__DimItemPrep"
),

size_run as (
    select 
        * 
    from "KNSDevDbt"."prod"."seed_SizeRun"
    where Code in (''M-Standard-1'',''F-Standard-1'',''U-Generic-1'')
),

current_stock as (
    select 
        ItemId,
        AvailableQuantity
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__CurrentStock"
),

temp_line as (
    select 
        i.ItemId,
        isnull(cs.AvailableQuantity,0) as AvailableQuantity,
        case when isnull(cs.AvailableQuantity,0) > 4 then 1 else 0 end as InStock,
        concat(i.Parent, ''-'', i.Color) as Item,
        isnull(sr.IsCore, 0) as Core 
    from dim_item i
    left join size_run sr on sr.Gender = i.Gender and sr.Size = i.Size
    left join current_stock cs on i.ItemId = cs.ItemId

),

temp_agg as (
    select 
        Item,
        case 
            when SUM(AvailableQuantity) = 0  then ''No Stock''
            when SUM(Instock) = COUNT(Instock) then ''Complete Run''
            when SUM(Instock*cast(Core as int)) = SUM(cast(Core as int)) and SUM(cast(Core as int))!= 0 then ''Core Run''
            when SUM(cast(Core as int)) > 0 and 1.0*SUM(Instock*cast(Core as int))/SUM(cast(Core as int)) < .3  then ''Hash''
            else ''Broken Core''
        end as BrokenStatus
    from temp_line
    group by Item
),

broken as (

    select 
        ItemId,
        BrokenStatus
    from temp_line tl
    join temp_agg ta on tl.Item = ta.Item

),

final as (
    select
        i.*,
        b.BrokenStatus
    from dim_item i
    left join broken b on i.ItemId = b.ItemId
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_prod_marts"."DimItem__dbt_tmp" FROM "KNSDevDbt"."dbt_prod_marts"."DimItem__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_prod_marts.DimItem__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_prod_marts_DimItem__dbt_tmp_cci'
        AND object_id=object_id('dbt_prod_marts_DimItem__dbt_tmp')
    )
    DROP index "dbt_prod_marts"."DimItem__dbt_tmp".dbt_prod_marts_DimItem__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_prod_marts_DimItem__dbt_tmp_cci
    ON "dbt_prod_marts"."DimItem__dbt_tmp"

   


  