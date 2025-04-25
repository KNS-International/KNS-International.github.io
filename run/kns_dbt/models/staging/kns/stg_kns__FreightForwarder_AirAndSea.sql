USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson_staging"."stg_kns__FreightForwarder_AirAndSea__dbt_tmp" as with 

source as (
    
    select * from "KNSDataLake"."kns"."FreightForwarder_AirAndSea"

),

cleaned as (

    select
		cast(SUBSTRING(trim(c.value),0,CHARINDEX('' '',trim(c.value),0)) as varchar(100)) as Number,
		''AirAndSea'' as FreightForwarder,
		cast([Load ETD] as date) as VesselLoadedAt,
        case 
            when [Last Sea Leg ATA] = '''' then null
            else cast([Last Sea Leg ATA] as date)
        end as EstimatedUSPortAt,
        case
            when [First Rail Leg ETD] = '''' then null
            else cast([First Rail Leg ETD] as date)
		end as EstimatedUSStartShipAt,
		cast(dateadd(day, iif(s.[Disch.] = ''USSLC'', 2, 5), nullif(s.[Disch. ETA], '''')) as date) as EstimatedArrivalAt
	from source s
	cross apply STRING_SPLIT([Container #], '','') c
	where trim(c.value) != ''''
	and trim(c.value) not like ''(%''
    and [Container #] is not null

)

select * from cleaned;
    ')

