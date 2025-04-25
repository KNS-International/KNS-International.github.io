-- Use the `ref` function to select from other models

select *
from "KNSDevDbt"."dbt_tlawson"."my_first_dbt_model"
where id = 1