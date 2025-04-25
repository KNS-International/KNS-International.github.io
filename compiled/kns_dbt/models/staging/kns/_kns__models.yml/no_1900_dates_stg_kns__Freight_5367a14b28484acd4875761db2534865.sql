
    select *
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_kns__FreightForwarder_SFI"
    where EstimatedUSStartShipAt = '1900-01-01'
