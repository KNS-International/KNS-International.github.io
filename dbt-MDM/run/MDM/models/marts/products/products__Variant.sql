
      
        
            
                
                
            
        
    

    

    merge into "KNSUnifiedMDM"."Products"."Variant" as DBT_INTERNAL_DEST
        using "KNSUnifiedMDM"."Products"."Variant__dbt_tmp" as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.Number = DBT_INTERNAL_DEST.Number

    
    when matched then update set
        "Number" = DBT_INTERNAL_SOURCE."Number","Code" = DBT_INTERNAL_SOURCE."Code","StyleId" = DBT_INTERNAL_SOURCE."StyleId","SizeId" = DBT_INTERNAL_SOURCE."SizeId","Status" = DBT_INTERNAL_SOURCE."Status","SellingStatus" = DBT_INTERNAL_SOURCE."SellingStatus","ShoeWidth" = DBT_INTERNAL_SOURCE."ShoeWidth","CalfWidth" = DBT_INTERNAL_SOURCE."CalfWidth","Parent" = DBT_INTERNAL_SOURCE."Parent","ClosureType" = DBT_INTERNAL_SOURCE."ClosureType","HeelType" = DBT_INTERNAL_SOURCE."HeelType","StyleType" = DBT_INTERNAL_SOURCE."StyleType","SizeRun" = DBT_INTERNAL_SOURCE."SizeRun","ColorName" = DBT_INTERNAL_SOURCE."ColorName","ColorClass" = DBT_INTERNAL_SOURCE."ColorClass","Subclass" = DBT_INTERNAL_SOURCE."Subclass","VendorSku" = DBT_INTERNAL_SOURCE."VendorSku","IsAnaplanActive" = DBT_INTERNAL_SOURCE."IsAnaplanActive","SellOutTargetAt" = DBT_INTERNAL_SOURCE."SellOutTargetAt","PlannedArrivalAt" = DBT_INTERNAL_SOURCE."PlannedArrivalAt","FirstSalesDateAt" = DBT_INTERNAL_SOURCE."FirstSalesDateAt","MSRP" = DBT_INTERNAL_SOURCE."MSRP","IsSupplies" = DBT_INTERNAL_SOURCE."IsSupplies","IsIntangible" = DBT_INTERNAL_SOURCE."IsIntangible","DirectSourcingModel" = DBT_INTERNAL_SOURCE."DirectSourcingModel"
    

    when not matched then insert
        ("Number", "Code", "StyleId", "SizeId", "Status", "SellingStatus", "ShoeWidth", "CalfWidth", "Parent", "ClosureType", "HeelType", "StyleType", "SizeRun", "ColorName", "ColorClass", "Subclass", "VendorSku", "IsAnaplanActive", "SellOutTargetAt", "PlannedArrivalAt", "FirstSalesDateAt", "MSRP", "IsSupplies", "IsIntangible", "DirectSourcingModel")
    values
        ("Number", "Code", "StyleId", "SizeId", "Status", "SellingStatus", "ShoeWidth", "CalfWidth", "Parent", "ClosureType", "HeelType", "StyleType", "SizeRun", "ColorName", "ColorClass", "Subclass", "VendorSku", "IsAnaplanActive", "SellOutTargetAt", "PlannedArrivalAt", "FirstSalesDateAt", "MSRP", "IsSupplies", "IsIntangible", "DirectSourcingModel");


  