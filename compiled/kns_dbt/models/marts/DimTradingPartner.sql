with 

trading_partners as (

    select
        TradingPartnerId,
        Name,
        Code,
        BillToCountry as ChannelType
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__TradingPartner"

),

final as (

    select
        *,
        iif (Name in ('DSW', 'MACYS', 'KOHLS', 'TARGET PLUS', 'NORDSTROM RACK', 'JCPENNEY', 'AMAZON', 'WALMART MARKETPLACE', 'KOHLS - WS'), 1, 0) as IsTopPartner
    from trading_partners

)

select * from final;