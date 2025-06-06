
      
        
            
                
                
            
        
    

    

    merge into "KNSUnifiedMDM"."Orders"."SalesOrderLine" as DBT_INTERNAL_DEST
        using "KNSUnifiedMDM"."Orders"."SalesOrderLine__dbt_tmp" as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.SourceId = DBT_INTERNAL_DEST.SourceId

    
    when matched then update set
        "SourceId" = DBT_INTERNAL_SOURCE."SourceId","SalesOrderId" = DBT_INTERNAL_SOURCE."SalesOrderId","ItemId" = DBT_INTERNAL_SOURCE."ItemId","ProductVariantId" = DBT_INTERNAL_SOURCE."ProductVariantId","QuantityOrdered" = DBT_INTERNAL_SOURCE."QuantityOrdered","QuantityShipped" = DBT_INTERNAL_SOURCE."QuantityShipped","QuantityCanceled" = DBT_INTERNAL_SOURCE."QuantityCanceled","UnitCostAmount" = DBT_INTERNAL_SOURCE."UnitCostAmount","UnitItemCOGSAmount" = DBT_INTERNAL_SOURCE."UnitItemCOGSAmount"
    

    when not matched then insert
        ("SourceId", "SalesOrderId", "ItemId", "ProductVariantId", "QuantityOrdered", "QuantityShipped", "QuantityCanceled", "UnitCostAmount", "UnitItemCOGSAmount")
    values
        ("SourceId", "SalesOrderId", "ItemId", "ProductVariantId", "QuantityOrdered", "QuantityShipped", "QuantityCanceled", "UnitCostAmount", "UnitItemCOGSAmount");


  