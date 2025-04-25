
    select *
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_kns__FreightForwarder_AirAndSea"
    where VesselLoadedAt = '1900-01-01'
