USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_staging"."stg_kns__FreightForwarder_DSV__dbt_tmp" as with 

source as (
    
        select * from "KNSDataLake"."kns"."FreightForwarder_DSV"

),

cleaned as (

        select
            cast(ContainerNumber as varchar(100)) as [Number],
            ''DSV'' as FreightForwarder,
            cast(max(iif(EventCode=''FLO'', EventDate, null)) as date) as VesselLoadedAt,
            cast(coalesce(
                max(iif(EventCode=''ARV'', EventDate, null)),
                max(iif(EventCode=''ETA'', EventDate, null))
            ) as date) as EstimatedUSPortAt,
            cast(null as date) as EstimatedUSStartShipAt,
            cast(max(iif(EventCode=''ESTIMATED_DELIVERY'', EventDate, null)) as date) as EstimatedArrivalAt
        from source
        where ContainerNumber is not null
            and ContainerNumber != ''''
        group by ContainerNumber

)

select * from cleaned;
    ')

