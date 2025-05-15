
      
        
            
                
                
            
        
    

    

    merge into "KNSUnifiedMDM"."Orders"."TradingPartner" as DBT_INTERNAL_DEST
        using "KNSUnifiedMDM"."Orders"."TradingPartner__dbt_tmp" as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.Name = DBT_INTERNAL_DEST.Name

    
    when matched then update set
        "Name" = DBT_INTERNAL_SOURCE."Name","FinancialChannelType" = DBT_INTERNAL_SOURCE."FinancialChannelType","FulfillmentChannelType" = DBT_INTERNAL_SOURCE."FulfillmentChannelType"
    

    when not matched then insert
        ("Name", "FinancialChannelType", "FulfillmentChannelType")
    values
        ("Name", "FinancialChannelType", "FulfillmentChannelType");


  