with 

trading_partners as (

    select
        TRADING_PARTNER_ID as TradingPartnerId,
        NAME as Name,
        CODE as Code,
        BILL_TO_COUNTRY as ChannelType
    from "KNSDevDbt"."dbt_tlawson_staging"."stg_deposco__TradingPartner"

),

final as (

    select
        *,
        iif (NAME in ('DSW', 'MACYS', 'KOHLS', 'TARGET PLUS', 'NORDSTROM RACK', 'JCPENNEY', 'AMAZON', 'WALMART MARKETPLACE', 'KOHLS - WS'), 1, 0) as IsTopPartner
    from trading_partners

)

select * from final;