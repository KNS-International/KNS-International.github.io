
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."FactOTIF__dbt_tmp__dbt_tmp_vw" as 
  


with line_disposition as (
    select
        oh.OrderHeaderId as OrderHeaderId,
        case
            when ol.OrderLineStatus = ''Canceled'' or oh.CurrentStatus = ''Canceled'' then ''Canceled''
            when (oh.KnsMtActualReleaseDate is not null 
                    and tp.ChannelType = ''Wholesale'')
                or (oh.ShippingStatus = 20 
                    and oh.KnsMtActualShipDate is not null 
                    and  tp.ChannelType != ''Wholesale'') 
                then ''Complete''
            when oh.CurrentStatus in (''New'', ''Back Ordered'', ''Released'', ''Complete'', ''Picking'', ''Hold'', ''Waiting For Rollback'') then ''Open''
            else ''Unknown''
        end as LineDisposition,
        tp.TradingPartnerId as TradingPartnerId
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh
    join "KNSDevDbt"."dbt_prod_marts"."DimTradingPartner" tp on tp.TradingPartnerId = oh.ConsigneePartnerId
    left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__CoHeader" ch on ch.CoHeaderId = oh.CoHeaderId
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol on ol.OrderHeaderId = oh.OrderHeaderId
    left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__CoLine" cl on cl.CoLineId = ol.CoLineId
    where oh.CreatedDate >= dateadd(day, -365, getdate())
        and oh.Type = ''Sales Order''
        and (oh.OrderSource is null or oh.OrderSource not in (''Shipped Sales'', ''Potential Sales'', ''Forecast Sales'', 
        ''Montly Net Revenue Percent'', ''Net Margin'', ''Net Revenue Forecast'', ''Historical NetSuite'', ''InvalidSource''))
        and tp.Name not in (''Walmart WFS'', ''MARKETING'', ''- No Customer/Project -'')
        and (oh.CustomerOrderNumber is null or oh.CustomerOrderNumber not like ''FBA%'')
        and oh.CurrentStatus not in (''Voided'')
        and ol.OrderLineStatus not in (''Voided'')
        and not(ol.OrderLineStatus = ''Canceled'' and cl.Status not in (''Canceled'', ''Review''))
        and not(oh.CurrentStatus = ''Canceled'' and ch.Status not in (''Canceled'', ''Review''))
),

grouped as (
    select
		ld.OrderHeaderId,
        case
            when sum(iif(ld.LineDisposition = ''Canceled'', 1, 0)) = count(*) then ''FullyCanceled''
            when sum(iif(ld.LineDisposition = ''Canceled'', 1, 0)) > 0 
                and sum(iif(ld.LineDisposition = ''Canceled'', 1, 0)) < count(*) then ''PartiallyCanceled''
            when sum(iif(ld.LineDisposition = ''Complete'', 1, 0)) = count(*) then ''CompleteInFull''
            when sum(iif(ld.LineDisposition = ''Unknown'', 1, 0)) > 0 then null
            else ''Open''
        end as OrderDisposition
	from line_disposition ld
    join "KNSDevDbt"."dbt_prod_marts"."DimTradingPartner" tp on tp.TradingPartnerId = ld.TradingPartnerId
    group by ld.OrderHeaderId
),

final as (
    select
        g.OrderHeaderId as OrderHeaderId,
        g.OrderDisposition,
        case
            when tp.ChannelType != ''Wholesale'' then
                dateadd(minute,
                    case
                        when oh.IsExpress = 1 then 14*60
                        else 17*60
                    end,
                    cast(cast(oh.KnsMtPlannedReleaseDate as date) as datetime)
                ) 
            else 
                dateadd(minute,
                    (23 * 60) + 59,
                    cast(cast(oh.KnsMtPlannedShipDate as date) as datetime)
                ) 
        end as TargetCompletionAt,
        case
            when tp.ChannelType != ''Wholesale'' then oh.KnsMtActualShipDate
            else oh.KnsMtActualReleaseDate
        end as ActualCompletionAt,
        case
            when tp.ChannelType != ''Wholesale'' then
                datediff(minute,
                    dateadd(minute,
                        case
                            when oh.IsExpress = 1 then 14*60
                            else 17*60
                        end,
                        cast(cast(oh.KnsMtPlannedReleaseDate as date) as datetime)
                    ),
                    oh.KnsMtActualShipDate) / 1440.0
            else
                datediff(minute,
                    dateadd(minute,
                        (23 * 60) + 59,
                        cast(cast(oh.KnsMtPlannedShipDate as date) as datetime)
                    ),
                    oh.KnsMtActualReleaseDate
                ) / 1440.0
        end as CompletionOffset,
        tp.TradingPartnerId
    from grouped g 
    join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh 
    on oh.OrderHeaderId = g.OrderHeaderId
    join "KNSDevDbt"."dbt_prod_marts"."DimTradingPartner" tp
    on tp.TradingPartnerId = oh.ConsigneePartnerId
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."FactOTIF__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."FactOTIF__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.FactOTIF__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_FactOTIF__dbt_tmp_cci'
        AND object_id=object_id('KNS_FactOTIF__dbt_tmp')
    )
    DROP index "KNS"."FactOTIF__dbt_tmp".KNS_FactOTIF__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_FactOTIF__dbt_tmp_cci
    ON "KNS"."FactOTIF__dbt_tmp"

   


  