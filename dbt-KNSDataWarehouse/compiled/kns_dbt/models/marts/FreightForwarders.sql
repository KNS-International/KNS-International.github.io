with

air_and_sea as (

    select 
        Number,
        FreightForwarder,
        min([VesselLoadedAt]) as VesselLoadedAt,
        min([EstimatedUSPortAt]) as EstimatedUSPortAt,
        min([EstimatedUSStartShipAt]) as EstimatedUSStartShipAt,
        min([EstimatedArrivalAt]) as EstimatedArrivalAt
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__FreightForwarder_AirAndSea"
    where Number != ''
        and Number is not null
    group by Number, FreightForwarder
),

dsv as (

    select * from "KNSDevDbt"."dbt_prod_staging"."stg_kns__FreightForwarder_DSV"

),

sfi as (

    select * from "KNSDevDbt"."dbt_prod_staging"."stg_kns__FreightForwarder_SFI"

),

po_master_file as (

    select 
        [Number],
        FreightForwarder,
        VesselLoadedAt,
        EstimatedUSPortAt,
        EstimatedUSStartShipAt,
        EstimatedArrivalAt
    from "KNSDevDbt"."dbt_prod_staging"."stg_kns__POMasterFile"
    group by [Number], FreightForwarder, VesselLoadedAt, EstimatedUSPortAt, EstimatedUSStartShipAt, EstimatedArrivalAt

),

combined as (

    select
        *,
        1 as priority
    from air_and_sea

    union all

    select
        *,
        2 as priority
    from dsv

    union all

    select
        *,
        3 as priority
    from sfi

    union all

    select
        *,
        4 as priority
    from po_master_file

),

ranked as (

    select 
        *,
        row_number() over (partition by Number order by priority) as row_num
    from combined

)

select 
    Number, FreightForwarder, VesselLoadedAt, EstimatedUSPortAt, EstimatedUSStartShipAt, EstimatedArrivalAt
from ranked
where row_num = 1