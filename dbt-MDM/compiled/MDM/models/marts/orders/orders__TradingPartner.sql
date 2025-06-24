

select 
  TradingPartnerId,
  Name,
  FulfillmentChannelType,
  FinancialChannelType,
  Code,
  case
    when IsReturnsPartner = 'TRUE' then 1
    else 0
  end as IsReturnsPartner
from "KNSUnifiedMDM"."prod"."stg_deposco__TradingPartner"