
  


with

brands as (
    select
        BrandId,
        Name as Brand,
        case
            when Name = 'Discontinued' then 4 
            when Name = 'Journee' then 0 
            when Name = 'Vance' then 2 
            when Name = 'Taft' then 1 
            when Name = 'Birdies' then 3 
        end as OrderIndex
    from "KNSDevDbt"."dbt_prod_staging"."stg_products__Brand"
)

select * from brands