

with ranked as (
  select 
    MerchandiseSubclass as Name,
    case
      when SubCategory is null or SubCategory in ('', '*No Category*', 'SHIPPING PROTECTION')
      then 'OTHER'
      else SubCategory
    end as Class,
    row_number() over (partition by MerchandiseSubclass order by (select null)) as rn
  from "KNSUnifiedMDM"."prod"."stg_salsify__Product"
  where 
    MerchandiseSubclass is not null
    and MerchandiseSubclass != ''
    and SubCategory is not null
    and SubCategory != ''
)

select 
  Name,
  Class
from ranked
where rn = 1