
    
    

select
    TradingPartnerId as unique_field,
    count(*) as n_records

from "KNSDevDbt"."dbt_tlawson_marts"."dim_trading_partner"
where TradingPartnerId is not null
group by TradingPartnerId
having count(*) > 1


