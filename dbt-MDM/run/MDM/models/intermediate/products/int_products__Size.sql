USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."int_products__Size__dbt_tmp" as with 

products as (
    select 
        MainSku,
        Size 
    from "KNSUnifiedMDM"."prod"."stg_salsify__Product"
),

sizes as (
    select
        SizeId,
        Name
    from "KNSUnifiedMDM"."prod"."stg_mdm_products__Size"
),

mapped as (
    select 
        p.MainSku as MainSku,
        case
            when p.Size = s.Name then s.SizeId
            when p.Size like ''S%'' then 22
            when p.Size like ''M%'' then 23 
            when p.Size like ''L%'' then 24
            when p.Size like ''XL%'' then 25
            when p.Size like ''X-L%'' then 25
            when p.Size like ''XXL%'' then 26
            when p.Size like ''XX-L%'' then 26
            else null
        end as SizeId
    from products p
    cross join sizes s
),

ranked as (
    select 
        MainSku as Number,
        SizeId,
        row_number() over (partition by MainSku order by (select null)) as rn
    from mapped
    where SizeId is not null
),

final as (
    select 
        Number,
        SizeId
    from ranked
    where rn = 1
)

select * from final;
    ')

