USE [KNSUnifiedMDM];
    
    

    

    
    USE [KNSUnifiedMDM];
    EXEC('
        create view "prod"."int_products__Style__dbt_tmp" as with products as (

    select distinct
        Style as Name,
        Vendor,
        VendorSku,
        Seasonality as Season,
        CaseQuantity,
        Gender,
        Brand,
        MerchandiseSubclass,
        SeasonBudget
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
    Vendor,
    VendorSku,
    Season,
    CaseQuantity,
    SeasonBudget,
    Gender,
    Brand,
    MerchandiseSubclass
from ranked
where rank = 1
    and Name is not null
    and Name != '''';
    ')

