
      
        
            
                
                
            
        
    

    

    merge into "KNSUnifiedMDM"."Products"."Style" as DBT_INTERNAL_DEST
        using "KNSUnifiedMDM"."Products"."Style__dbt_tmp" as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.Name = DBT_INTERNAL_DEST.Name

    
    when matched then update set
        "Code" = DBT_INTERNAL_SOURCE."Code","CatalogId" = DBT_INTERNAL_SOURCE."CatalogId","SubclassId" = DBT_INTERNAL_SOURCE."SubclassId","Vendor" = DBT_INTERNAL_SOURCE."Vendor","VendorSku" = DBT_INTERNAL_SOURCE."VendorSku","Season" = DBT_INTERNAL_SOURCE."Season","CaseQuantity" = DBT_INTERNAL_SOURCE."CaseQuantity","Name" = DBT_INTERNAL_SOURCE."Name","Gender" = DBT_INTERNAL_SOURCE."Gender","SeasonBudget" = DBT_INTERNAL_SOURCE."SeasonBudget"
    

    when not matched then insert
        ("Code", "CatalogId", "SubclassId", "Vendor", "VendorSku", "Season", "CaseQuantity", "Name", "Gender", "SeasonBudget")
    values
        ("Code", "CatalogId", "SubclassId", "Vendor", "VendorSku", "Season", "CaseQuantity", "Name", "Gender", "SeasonBudget");


  