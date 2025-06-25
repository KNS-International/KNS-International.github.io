
  


with 

trading_partners as (

    select
        TradingPartnerId,
        Name,
        Code,
        FulfillmentChannelType as ChannelType
    from "KNSDevDbt"."dbt_prod_staging"."stg_orders__TradingPartner"

),

final as (

    select
        *,
        iif (Name in ('DSW', 'MACYS', 'KOHLS', 'TARGET PLUS', 'NORDSTROM RACK', 'JCPENNEY', 'AMAZON', 'WALMART MARKETPLACE', 'KOHLS - WS'), 1, 0) as IsTopPartner
    from trading_partners

)

select * from final;