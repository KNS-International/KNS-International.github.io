with

source as (

    select * from "KNSDataLake"."netsuite"."transaction"

),

cleaned as (

    select
        cast(id as bigint) as Id,
        cast(custbody_kns_po as nvarchar(4000)) as Memo,
        cast(entity as bigint) as Entity,
        cast(trandate as date) as TranDate,
        cast(tranid as nvarchar(90)) as TranId,
        cast(otherrefnum as nvarchar(90)) as OtherRefNum,
        cast(cseg_kns_brand_2024 as bigint) as CsegKnsBrand2024,
        cast(cseg_kns_productcat as bigint) as CsegKnsProductCat,
        cast(cseg_kns_prod_subcl as bigint) as CsegKnsProdSubcl,
        cast(duedate as date) as DueDate,
        cast(custbody_kns_po as nvarchar(4000)) as CustbodyKnsPo,
        cast(custbody_kns_season_po as nvarchar(4000)) as CustbodyKnsSeasonPo,
        cast(custbody_kns_x_factory_date as datetime2(7)) as CustbodyKnsXFactoryDate,
        cast(custbody_knsconfirmxfact as datetime2(7)) as CustbodyKnsConfirmXFact,
        cast(custbody_knsactualxfact as datetime2(7)) as CustbodyKnsActualXFact,
        cast(custbody_knsestindcdate as datetime2(7)) as CustbodyKnsEstInDCDate,
        cast(status as nvarchar(2)) as Status,
        cast(type as nvarchar(8)) as Type
    from source

)

select * from cleaned