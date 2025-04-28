
  
    USE [KNSDevDbt];
    USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_marts"."FactSalesLine__dbt_tmp__dbt_tmp_vw" as with

deposco as (
    select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco"
),

returns_accruals as (
  select * from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_ReturnsAccruals"
)

-- freight_out_cogs as (

--   select 
--     *
--   from deposco d 
--   join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__TradingPartner" tp
--   on d.TradingPartnerId = tp.TradingPartnerId
--   join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderLine" ol 
--   on ol.OrderLineId = right(d.Number, len(d.Number) - len(''Deposco/'')) 
--   join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__OrderHeader" oh
--   on ol.OrderHeaderId = oh.OrderHeaderId
--   left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__ShipmentOrderHeader" soh 
--   on ol.OrderHeaderId = soh.OrderHeaderId
--   left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__Shipment" s 
--   on soh.ShipmentId = s.ShipmentId and s.FreightTermsType = ''Prepaid''
--   left join "KNSDevDbt"."dbt_prod_staging"."stg_deposco__ShipmentLine" sl
--   on s.ShipmentId = sl.ShipmentId
--   where d.Number like ''Deposco/%''
--   and tp.UpsAccountNumber = ''79V143''
--   group by d.Number, d.Quantity
  
-- )

select * from deposco;
    ')

EXEC('
            SELECT * INTO "KNSDevDbt"."dbt_prod_marts"."FactSalesLine__dbt_tmp" FROM "KNSDevDbt"."dbt_prod_marts"."FactSalesLine__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS dbt_prod_marts.FactSalesLine__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDevDbt];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'dbt_prod_marts_FactSalesLine__dbt_tmp_cci'
        AND object_id=object_id('dbt_prod_marts_FactSalesLine__dbt_tmp')
    )
    DROP index "dbt_prod_marts"."FactSalesLine__dbt_tmp".dbt_prod_marts_FactSalesLine__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX dbt_prod_marts_FactSalesLine__dbt_tmp_cci
    ON "dbt_prod_marts"."FactSalesLine__dbt_tmp"

   


  