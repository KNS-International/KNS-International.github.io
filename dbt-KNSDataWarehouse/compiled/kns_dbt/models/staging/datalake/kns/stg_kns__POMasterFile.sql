with 

source as (
    
    select * from "KNSDataLake"."kns"."POMasterFile"

),

cleaned as (

    select
        ContainerNumber as [Number],
        'UnknownFromMaster' as FreightForwarder,
        cast(null as date) as VesselLoadedAt,
        cast(null as date) as EstimatedUSPortAt,
        cast(null as date) as EstimatedUSStartShipAt,
        cast(null as date) as EstimatedArrivalAt,
        cast(PONumber as nvarchar(128)) as PONumber,
        cast(Color as nvarchar(128)) as Color,
        cast(Parent as nvarchar(128)) as Parent
    from source 
    where ContainerNumber is not null
    and ContainerNumber != ''

)

select * from cleaned