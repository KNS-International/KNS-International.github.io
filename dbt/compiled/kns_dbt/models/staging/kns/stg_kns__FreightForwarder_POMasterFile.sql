with 

source as (
    
    select ContainerNumber from "KNSDataLake"."kns"."POMasterFile"

),

cleaned as (

    select
        ContainerNumber as [Number],
        'UnknownFromMaster' as FreightForwarder,
        cast(null as date) as VesselLoadedAt,
        cast(null as date) as EstimatedUSPortAt,
        cast(null as date) as EstimatedUSStartShipAt,
        cast(null as date) as EstimatedArrivalAt
    from source 
    where ContainerNumber is not null
    and ContainerNumber != ''

)

select * from cleaned