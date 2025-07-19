
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactFreightContainerLine__dbt_tmp__dbt_tmp_vw" as 
  


with

shipments as (
    select
        si.Id as FreightContainerLineId,
        t.CustBodyKnsPo as PONumber,
        s.ActualShippingDate as DepartureAt,
        cast(t.CustBodyKnsActualXFact as date) as ActualXFAt,
        s.ActualDeliveryDate as ActualInDCAt,
        s.ExpectedDeliveryDate as ExpectedInDcAt,
        si.QuantityExpected as ExpectedQuantity,
        si.QuantityReceived as ReceivedQuantity,
        i.ExternalId as Item,
        s.VesselNumber as Container
    from "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__InboundShipment" s 
    left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__InboundShipmentItem" si 
        on s.Id = si.InboundShipmentId
    left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__TransactionLine" tl
        on si.ShipmentItemTransactionId = tl.UniqueKey
    left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Transaction" t
        on tl.[Transaction] = t.Id
    left join "KNSDevDbt"."dbt_prod_staging"."stg_netsuite__Item" i
        on tl.Item = i.Id
),

final as (
    select 
        s.FreightContainerLineId,
        s.Container,
        s.PONumber,
        s.ActualXFAt,
        s.DepartureAt,
        s.ExpectedInDCAt,
        s.ActualInDCAt,
        s.ExpectedQuantity,
        s.ReceivedQuantity,
        i.ItemId
    from shipments s
    left join "KNSDataWarehouse"."Deposco"."DimItem" i
        on s.Item = i.Number
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactFreightContainerLine__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactFreightContainerLine__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactFreightContainerLine__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactFreightContainerLine__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactFreightContainerLine__dbt_tmp')
    )
    DROP index "KNS"."FactFreightContainerLine__dbt_tmp".KNS_FactFreightContainerLine__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactFreightContainerLine__dbt_tmp_cci
    ON "KNS"."FactFreightContainerLine__dbt_tmp"

   


  