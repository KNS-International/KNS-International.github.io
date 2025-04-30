USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_staging"."stg_kns__FreightForwarder_SFI__dbt_tmp" as with 

source as (
    
    select * from "KNSDataLake"."kns"."FreightForwarder_SFI"

),

cleaned as (

    select
        cast([Container No.] as varchar(100)) as [Number],
        ''SFI'' as FreightForwarder,
        cast(null as date) as VesselLoadedAt,
        cast(coalesce(ATA, ETA) as date) as EstimatedUSPortAt,
        cast(dateadd(day, -7, [Place of Delivery ETA]) as date) as EstimatedUSStartShipAt,
        cast(dateadd(day, 4, [Place of Delivery ETA]) as date) as EstimatedArrivalAt
    from source
    where [Container No.] is not null
    and [Container No.] != ''''
        
)

select * from cleaned;
    ')

