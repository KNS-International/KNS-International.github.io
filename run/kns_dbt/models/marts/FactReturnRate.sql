
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_marts"."FactReturnRate__dbt_tmp__dbt_tmp_vw" as with

params as (
    select 
        70 as stat_threshold,
        1 as return_processing_day
),

returns_temp as (

    select * from "KNSDevDbt"."dbt_tlawson_intermediate"."int_sales__ReturnRatePrep"

),

median as (

    select distinct
        TradingPartner,
        case
            when (select count(*)
                from returns_temp temp
                where ReturnDays is not null and main.TradingPartner = temp.TradingPartner) > params.stat_threshold
            then
                ((select max(num) 
                from (select top 50 percent ReturnDays AS num 
                        from returns_temp temp 
                        where ReturnDays is not null and main.TradingPartner = temp.TradingPartner 
                        order by ReturnDays) onehalf)
                +
                (select min(num) 
                from (select top 50 percent ReturnDays AS num 
                        from returns_temp temp 
                        where ReturnDays is not null and main.TradingPartner = temp.TradingPartner 
                        order by ReturnDays desc) otherhalf)
                ) / 2 + params.return_processing_day
            else null
        end as MedianDays
    from returns_temp main
    cross join params

),

aggregated_data as (

    select 
        TradingPartner,
        Parent,
        Item,
        sum(coalesce(ReturnQuantity, 0)) as TotalReturnQuantity,
        sum(coalesce(PurchasedQuantity, 0)) as TotalPurchasedQuantity
    from returns_temp
    group by TradingPartner, Parent, Item

),

final as (

    select 
        a.TradingPartner,
        a.Item as ParentColor,
        case 
        when a.TotalPurchasedQuantity > params.stat_threshold 
                and a.TotalReturnQuantity < a.TotalPurchasedQuantity
        then cast(a.TotalReturnQuantity as float) / a.TotalPurchasedQuantity
        else NULL
        end as PercentReturnRate,
        ISNULL(m.MedianDays, 60) as ReturnLagDays
    from aggregated_data a
    left join median m on m.TradingPartner = a.TradingPartner
    cross join params
    where a.TotalPurchasedQuantity > params.stat_threshold 
    and a.TotalReturnQuantity < a.TotalPurchasedQuantity 
    and a.TotalPurchasedQuantity > 0

)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_tlawson_marts"."FactReturnRate__dbt_tmp" FROM "KNSDevDbt"."dbt_tlawson_marts"."FactReturnRate__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_tlawson_marts.FactReturnRate__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_tlawson_marts_FactReturnRate__dbt_tmp_cci'
        AND object_id=object_id('dbt_tlawson_marts_FactReturnRate__dbt_tmp')
    )
    DROP index "dbt_tlawson_marts"."FactReturnRate__dbt_tmp".dbt_tlawson_marts_FactReturnRate__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_tlawson_marts_FactReturnRate__dbt_tmp_cci
    ON "dbt_tlawson_marts"."FactReturnRate__dbt_tmp"

   


  