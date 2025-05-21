
      
        
            
                
                
            
                
                
            
        
    

    

    merge into "KNSUnifiedMDM"."Orders"."SalesOrder" as DBT_INTERNAL_DEST
        using "KNSUnifiedMDM"."Orders"."SalesOrder__dbt_tmp" as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.SourceId = DBT_INTERNAL_DEST.SourceId and DBT_INTERNAL_SOURCE.SourceSystem = DBT_INTERNAL_DEST.SourceSystem

    
    when matched then update set
        "PONumber" = DBT_INTERNAL_SOURCE."PONumber","TradingPartnerId" = DBT_INTERNAL_SOURCE."TradingPartnerId","PlacedAt" = DBT_INTERNAL_SOURCE."PlacedAt","ContractualShipAt" = DBT_INTERNAL_SOURCE."ContractualShipAt","PlannedShipAt" = DBT_INTERNAL_SOURCE."PlannedShipAt","Status" = DBT_INTERNAL_SOURCE."Status","SourceId" = DBT_INTERNAL_SOURCE."SourceId","SourceSystem" = DBT_INTERNAL_SOURCE."SourceSystem","ShippingVia" = DBT_INTERNAL_SOURCE."ShippingVia","ShippingCarrier" = DBT_INTERNAL_SOURCE."ShippingCarrier","ShippedAt" = DBT_INTERNAL_SOURCE."ShippedAt","FreightOutCOGSAmount" = DBT_INTERNAL_SOURCE."FreightOutCOGSAmount","DiscountAmount" = DBT_INTERNAL_SOURCE."DiscountAmount"
    

    when not matched then insert
        ("PONumber", "TradingPartnerId", "PlacedAt", "ContractualShipAt", "PlannedShipAt", "Status", "SourceId", "SourceSystem", "ShippingVia", "ShippingCarrier", "ShippedAt", "FreightOutCOGSAmount", "DiscountAmount")
    values
        ("PONumber", "TradingPartnerId", "PlacedAt", "ContractualShipAt", "PlannedShipAt", "Status", "SourceId", "SourceSystem", "ShippingVia", "ShippingCarrier", "ShippedAt", "FreightOutCOGSAmount", "DiscountAmount");


  