with 

source as (

    select * from "KNSDataLake"."netsuite"."InboundShipment"

),

cleaned as (

    select 
        cast(id as bigint) as Id,
        cast(vesselnumber as nvarchar(400)) as VesselNumber,
        cast(actualdeliverydate as datetime2(7)) as ActualDeliveryDate,
        cast(expecteddeliverydate as datetime2(7)) as ExpectedDeliveryDate,
        cast(actualshippingdate as datetime2(7)) as ActualShippingDate,
        cast(expectedshippingdate as datetime2(7)) as ExpectedShippingDate
    from source 
        
)

select * from cleaned