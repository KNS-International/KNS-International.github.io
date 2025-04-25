with 

brands as (
    select * from "KNSDevDbt"."tlawson"."seed_brands"
),

marketing_data as (

    select * from "KNSDevDbt"."dbt_tlawson_intermediate"."int_marketing__SourcesMapped"

),

final as (
    select 
        m.[Date],
        m.[AdName],
        m.[AdSet],
        m.[Campaign],
        m.TradingPartnerId,
        m.[Platform],
        m.Channel,
        m.Type,
        b.BrandId,
        m.ObjectiveMapped as Objective,
        m.LandingPageMapped as LandingPage,
        m.ParsedClass1 as Class1,
        m.ParsedClass2 as Class2,
        m.ParsedClass3 as Class3,
        cast(Spend as decimal(19, 4)) as Spend,
        cast(ClickThrough as decimal(19, 4)) as ClickThrough,
        cast(Impressions as decimal(19, 4)) as Impressions,
        cast(Conversions as decimal(19, 4)) as Conversions,
        cast(SalesDollars as decimal(19, 4)) as SalesDollars,
        cast(SalesUnits as decimal(19, 4)) as SalesUnits

    from marketing_data m
    left join brands b 
        on b.Brand = m.BrandMapping
    where TradingPartnerId is not null
)

select * from final;