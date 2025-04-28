
      

    
        
            delete from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco"
            where (
                Number) in (
                select (Number)
                from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco__dbt_tmp"
            )
    OPTION (LABEL = 'dbt-sqlserver');

        
    

    insert into "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco" ("Number", "ItemId", "TradingPartnerId", "Amount", "Quantity", "PoNumber", "PlacedDate", "CreatedDate", "ContractualShipDate", "PlannedShipDate", "ActualShipDate", "HeaderCurrentStatus", "HeaderShippingStatus", "LineStatus", "HandlingFee", "Season")
    (
        select "Number", "ItemId", "TradingPartnerId", "Amount", "Quantity", "PoNumber", "PlacedDate", "CreatedDate", "ContractualShipDate", "PlannedShipDate", "ActualShipDate", "HeaderCurrentStatus", "HeaderShippingStatus", "LineStatus", "HandlingFee", "Season"
        from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco__dbt_tmp"
    )
    OPTION (LABEL = 'dbt-sqlserver');


  