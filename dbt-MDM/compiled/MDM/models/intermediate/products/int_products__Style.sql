with products as (

    select distinct
        Style as Name,
        Vendor,
        Seasonality as Season,
        CaseQuantity,
        Gender,
        Brand,
        SeasonBudget,
        case
            when SubCategory is null or SubCategory in ('', '*No Category*', 'SHIPPING PROTECTION')
            then 'OTHER'
            else SubCategory
        end as Class
    from "KNSUnifiedMDM"."prod"."stg_salsify__Product"

),

ranked as (

    select 
        *,
        row_number() over (
            partition by Name 
            order by (select null)
        ) as rank
    from products

)

select
    Name,
    Class,
    Vendor,
    Season,
    CaseQuantity,
    SeasonBudget,
    Gender,
    Brand
from ranked
where rank = 1
    and Name is not null
    and Name != ''