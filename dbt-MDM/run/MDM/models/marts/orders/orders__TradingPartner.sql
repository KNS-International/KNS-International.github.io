
      
        
            
                
                
            
        
    

    

    merge into "KNSUnifiedMDM"."Orders"."TradingPartner" as DBT_INTERNAL_DEST
        using "KNSUnifiedMDM"."Orders"."TradingPartner__dbt_tmp" as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.TradingPartnerId = DBT_INTERNAL_DEST.TradingPartnerId

    
    when matched then update set
        "TradingPartnerId" = DBT_INTERNAL_SOURCE."TradingPartnerId","Name" = DBT_INTERNAL_SOURCE."Name","FinancialChannelType" = DBT_INTERNAL_SOURCE."FinancialChannelType","FulfillmentChannelType" = DBT_INTERNAL_SOURCE."FulfillmentChannelType","Code" = DBT_INTERNAL_SOURCE."Code","IsReturnsPartner" = DBT_INTERNAL_SOURCE."IsReturnsPartner"
    

    when not matched then insert
        ("TradingPartnerId", "Name", "FinancialChannelType", "FulfillmentChannelType", "Code", "IsReturnsPartner")
    values
        ("TradingPartnerId", "Name", "FinancialChannelType", "FulfillmentChannelType", "Code", "IsReturnsPartner");


  