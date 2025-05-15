

with styles as ( 
    select * from "KNSUnifiedMDM"."prod"."int_products__Style"
),

catalog as (
    select * from "KNSUnifiedMDM"."prod"."stg_mdm_products__Catalog"
),

subclass as (
    select * from "KNSUnifiedMDM"."prod"."stg_mdm_products__Subclass"
),

final as (
    select 
        null as Code,
        c.CatalogId,
        sc.SubclassId,
        s.Vendor,
        s.VendorSku,
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
    left join subclass sc
    on s.MerchandiseSubclass = sc.Name
    where s.Name is not null
        and s.Name != ''
)

select * from final