USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_staging"."stg_kns_FreightForwarder_POMasterFile__dbt_tmp" as with 

source as (
    
    select ContainerNumber from "KNSDataLake"."kns"."POMasterFile"

),

cleaned as (

    select
        ContainerNumber as [Number],
        ''UnknownFromMaster'' as FreightForwarder,
        try_cast(null as date) as VesselLoadedAt,
        try_cast(null as date) as EstimatedUSPortAt,
        try_cast(null as date) as EstimatedUSStartShipAt,
        try_cast(null as date) as EstimatedArrivalAt
    from source 
    where ContainerNumber is not null
    and ContainerNumber != ''''

)

select * from cleaned;
    ')

