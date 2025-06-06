

with styles as ( 
    select * from "KNSUnifiedMDM"."prod"."int_products__Style"
),

catalog as (
    select * from "KNSUnifiedMDM"."prod"."stg_mdm_products__Catalog"
),

final as (
    select 
        null as Code,
        c.CatalogId,\
        s.Class,
        s.Vendor,
        s.Season,
        s.CaseQuantity,
        s.Name,
        case 
            when s.Gender = '' then null 
            else s.Gender 
        end as Gender,
        s.SeasonBudget
    from styles s
    left join catalog c
    on s.Brand = c.Name
    where s.Name is not null
        and s.Name != ''
)

select * from final