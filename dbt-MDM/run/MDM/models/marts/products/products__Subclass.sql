
      
        
            
                
                
            
                
                
            
        
    

    

    merge into "KNSUnifiedMDM"."Products"."Subclass" as DBT_INTERNAL_DEST
        using "KNSUnifiedMDM"."Products"."Subclass__dbt_tmp" as DBT_INTERNAL_SOURCE
        on DBT_INTERNAL_SOURCE.Class = DBT_INTERNAL_DEST.Class and DBT_INTERNAL_SOURCE.Name = DBT_INTERNAL_DEST.Name

    
    when matched then update set
        "Name" = DBT_INTERNAL_SOURCE."Name","Class" = DBT_INTERNAL_SOURCE."Class"
    

    when not matched then insert
        ("Name", "Class")
    values
        ("Name", "Class");


  