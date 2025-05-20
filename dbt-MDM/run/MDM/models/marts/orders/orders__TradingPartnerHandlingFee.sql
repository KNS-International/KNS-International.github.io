
      
        
            
                
                
            
                
                
            
        
    

    

    merge into "KNSUnifiedMDM"."Orders"."TradingPartnerHandlingFee" as DBT_INTERNAL_DEST
        using "KNSUnifiedMDM"."Orders"."TradingPartnerHandlingFee__dbt_tmp" as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.TradingPartnerId = DBT_INTERNAL_DEST.TradingPartnerId and DBT_INTERNAL_SOURCE.StartDate = DBT_INTERNAL_DEST.StartDate

    
    when matched then update set
        "TradingPartnerId" = DBT_INTERNAL_SOURCE."TradingPartnerId","StartDate" = DBT_INTERNAL_SOURCE."StartDate","EndDate" = DBT_INTERNAL_SOURCE."EndDate","HandlingFeeType" = DBT_INTERNAL_SOURCE."HandlingFeeType","HandlingFee" = DBT_INTERNAL_SOURCE."HandlingFee"
    

    when not matched then insert
        ("TradingPartnerId", "StartDate", "EndDate", "HandlingFeeType", "HandlingFee")
    values
        ("TradingPartnerId", "StartDate", "EndDate", "HandlingFeeType", "HandlingFee");


  