with

deposco as (
    select * from "KNSDevDbt"."dbt_tlawson_intermediate"."int_sales__FactSalesLine_Deposco"
),

returns_accruals as (
  select * from "KNSDevDbt"."dbt_tlawson_intermediate"."int_sales__FactSalesLine_ReturnsAccruals"
),

freight_out_cogs as (

  select 
    *
  from deposco d 
  join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__TradingPartner" tp
  on d.TradingPartnerId = tp.TradingPartnerId
  join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__OrderLine" ol 
  on ol.OrderLineId = right(d.Number, len(d.Number) - len('Deposco/')) 
  join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__OrderHeader" oh
  on ol.OrderHeaderId = oh.OrderHeaderId
  left join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__ShipmentOrderHeader" soh 
  on ol.OrderHeaderId = soh.OrderHeaderId
  left join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__Shipment" s 
  on soh.ShipmentId = s.ShipmentId and s.FreightTermsType = 'Prepaid'
  left join "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__ShipmentLine" sl
  on s.ShipmentId = sl.ShipmentId
  where d.Number like 'Deposco/%'
  and tp.UpsAccountNumber = '79V143'
  group by d.Number, d.Quantity
  
)

select * from deposco