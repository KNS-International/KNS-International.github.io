
    select *
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_kns__FreightForwarder_DSV"
    where EstimatedUSPortAt = '1900-01-01'
