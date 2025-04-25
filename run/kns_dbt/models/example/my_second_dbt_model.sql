USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_tlawson"."my_second_dbt_model__dbt_tmp" as -- Use the `ref` function to select from other models

select *
from "KNSDevDbt"."dbt_tlawson"."my_first_dbt_model"
where id = 1;
    ')

