USE [KNSDevDbt];
    
    

    

    
    USE [KNSDevDbt];
    EXEC('
        create view "dbt_prod_intermediate"."int_marketing__SourcesMapped__dbt_tmp" as with

sources as (
    select * from "KNSDevDbt"."dbt_prod_intermediate"."int_marketing__SourcesUnioned"
),

old_names as (
  select 
    OldCampaignName,
    NewCampaignName 
  from "KNSDevDbt"."dbt_prod_staging"."stg_marketing__CampaignMap"
),

new_names as (
  select 
    Date,
    AdName,
    AdSet,
    case
      when o.NewCampaignName is not null then o.NewCampaignName
      else s.Campaign
    end as Campaign,
    TradingPartnerId,
    Platform,
    Channel,
    Type,
    Brand,
    Spend,
    ClickThrough,
    Impressions,
    Conversions,
    SalesDollars,
    SalesUnits
  from sources s
  left join old_names o
    on s.Campaign = o.OldCampaignName
),

-- Step 1: Extract the first token from Campaign (up to the first space, or the whole Campaign)
base_campaign as (
  select 
    *,
    ltrim(rtrim(Campaign)) as FirstSegment  -- keep the whole thing, just trim whitespace
  from new_names
),


-- Step 2: Count the number of periods in FirstSegment
campaign_with_count as (

    select *,
           len(FirstSegment) - len(replace(FirstSegment, ''.'', '''')) as PeriodCount
    from base_campaign

),

-- Step 3: Convert FirstSegment into XML to enable splitting
campaign_xml as (

    select *,
           cast(''<i>'' + 
			 replace(
				 replace(
					 replace(
						 replace(FirstSegment, ''&'', ''&amp;''), 
					 ''<'', ''&lt;''), 
				 ''>'', ''&gt;''), 
			 ''.'', ''</i><i>'') 
			 + ''</i>'' as xml) as XMLParts
    from campaign_with_count

),

-- Step 4: Parse out each dot-delimited part from the XML
parsed_campaign as (

    select 
      Date, AdName, AdSet, Campaign, Brand, TradingPartnerId, Platform, Channel, Type,
      Spend, ClickThrough, Impressions, Conversions, SalesDollars, SalesUnits,
      XMLParts, PeriodCount, FirstSegment,
      XMLParts.value(''(/i)[1]'', ''varchar(100)'') as Part1,  -- Expecting the brand letter (J, T, V)
      XMLParts.value(''(/i)[2]'', ''varchar(100)'') as Part2,
      XMLParts.value(''(/i)[3]'', ''varchar(100)'') as Part3,  -- Code for Objective mapping
      XMLParts.value(''(/i)[4]'', ''varchar(100)'') as Part4,  -- Code for LandingPage mapping
      XMLParts.value(''(/i)[5]'', ''varchar(100)'') as Part5,  -- (Optional) Channel from parsed string if needed
      XMLParts.value(''(/i)[6]'', ''varchar(100)'') as Part6,  -- Class1
      XMLParts.value(''(/i)[7]'', ''varchar(100)'') as Part7,  -- Class2
      XMLParts.value(''(/i)[8]'', ''varchar(100)'') as Part8,  -- Class3
      XMLParts.value(''(/i)[9]'', ''varchar(100)'') as Part9   -- Extra (not used)
    from campaign_xml

),

-- Step 5: Apply your mapping rules if PeriodCount = 8 (i.e. 9 parts)
complete_parse as (

    select
      p.*,
      iif(PeriodCount = 8, Part2, null) as TradingPartnerCode,
      -- Map the brand letter from Part1 to the full brand name; this will be used to join to dim_brand for BrandId
      case 
        when PeriodCount = 8 then 
          case p.Part1
              when ''J'' then ''Journee''
              when ''T'' then ''Taft''
              when ''V'' then ''Vance''
              when ''B'' then ''Birdies''
              else null
          end
        when Brand is not null then Brand
        else null
      end as BrandMapping,
      -- Map Part3 to Objective using your defined codes
      case 
        when PeriodCount = 8 then
          case p.Part3
              when ''TOP'' then ''Top Funnel / Awareness''
              when ''MID'' then ''Mid Funnel''
              when ''BOT'' then ''Bottom Funnel / Conversions''
              when ''RTA'' then ''Retargeting''
              when ''PRO'' then ''Prospecting''
              when ''RET'' then ''Retention''
              when ''NSE'' then ''NBSearch''
              when ''BSE'' then ''BrandSearch''
              when ''PMA'' then ''PMax''
              when ''BSH'' then ''BrandShopping''
              when ''NSH'' then ''NBShopping''
              else null
          end
        else null
      end as ObjectiveMapped,
      -- Map Part4 to LandingPage using your provided options
      case 
        when PeriodCount = 8 then 
          case p.Part4
              when ''Brand''   then ''Brand Page''
              when ''Product'' then ''Product Page''
              when ''DPA''     then ''Dynamic Product''
              when ''SPA''     then ''Sponsored Product''
              when ''CAT''     then ''Category/Collection''
              else null
          end
        else null
      end as LandingPageMapped,
      -- Directly assign Class1, Class2, Class3 from parts 6, 7, and 8 respectively (if PeriodCount = 8)
      case when PeriodCount = 8 then p.Part6 else null end as ParsedClass1,
      case when PeriodCount = 8 then p.Part7 else null end as ParsedClass2,
      case when PeriodCount = 8 then p.Part8 else null end as ParsedClass3
    from parsed_campaign p

)

select * from complete_parse;;
    ')

