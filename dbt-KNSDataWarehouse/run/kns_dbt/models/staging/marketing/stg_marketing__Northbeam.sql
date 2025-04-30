USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_marketing__Northbeam__dbt_tmp" as with 

source as (

    select * from "KNSDataLake"."marketing"."Northbeam"

),

cleaned as (

    select 
        cast(date as date) as date,
        cast(breakdown_platform_northbeam as nvarchar(256)) as breakdown_platform_northbeam,
        cast(campaign_name as nvarchar(256)) as campaign_name,
        cast(adset_name as nvarchar(256)) as adset_name,
        cast(ad_name as nvarchar(256)) as ad_name,    
        cast(attribution_model as nvarchar(256)) as attribution_model,
        cast(attribution_window as nvarchar(256)) as attribution_window,
        cast(ctr as decimal(19, 4)) as ctr,
        cast(imprs as decimal(19, 4)) as imprs,
        cast(attributed_rev as decimal(19, 4)) as attributed_rev,
        cast(spend as decimal(19, 4)) as spend,
        cast(visits as decimal(19, 4)) as visits
    from source
    where 
    date >= dateadd(year, -2, getdate())

)

select * from cleaned;;
    ')

