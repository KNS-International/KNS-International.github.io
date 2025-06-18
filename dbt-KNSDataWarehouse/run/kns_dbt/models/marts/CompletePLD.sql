
  
    USE [KNSDataWarehouse];
    USE [KNSDataWarehouse];
    
    

    

    
    USE [KNSDataWarehouse];
    EXEC('
        create view "KNS"."CompletePLD__dbt_tmp__dbt_tmp_vw" as 
  


with

item as (
    select
        ItemId,
        Number 
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__DimItemPrep"
),

trading_partner as (
    select
        TradingPartnerId,
        Name
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__TradingPartner"
),

price_list as (
    select
        PriceListId,
        TradingPartnerId
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__PriceList"
),

price_list_detail as (
    select
        PriceListDetailId,
        PriceListId,
        ItemId,
        SalesPrice,
        SalesEffectiveStart,
        SalesEffectiveEnd
    from "KNSDevDbt"."dbt_prod_staging"."stg_deposco__PriceListDetail"
),

pld_grouped as (
    select
        i.ItemId,
        i.Number as SKU,
        tp.Name as TradingPartnerName,
        pl.TradingPartnerId,
        pld.SalesPrice as CurrentPLDPrice,
        pld.SalesEffectiveStart as PriceStartAt,
        pld.PriceListDetailId
    from item i
    left join price_list_detail pld
        on i.ItemId = pld.ItemId
    left join price_list pl 
        on pld.PriceListId = pl.PriceListId
    left join trading_partner tp 
        on pl.TradingPartnerId = tp.TradingPartnerId
    where pld.SalesEffectiveEnd is null
),

sales as (
    select
        Number,
        ItemId,
        TradingPartnerId,
        PlacedDate,
        row_number() over (
            partition by ItemId, TradingPartnerId 
            order by PlacedDate desc
        ) as rn
    from "KNSDevDbt"."dbt_prod_intermediate"."int_sales__FactSalesLine_Deposco"
    where Quantity is not null 
        and Quantity > 0
),

latest_sales as (
    select
        Number,
        ItemId,
        TradingPartnerId,
        PlacedDate
    from sales
    where rn = 1
),

pld_sales_joined as (
    select 
        s.Number as FactSalesLineNumber,
        pld.ItemId,
        pld.SKU,
        pld.TradingPartnerName,
        pld.CurrentPLDPrice,
        pld.PriceStartAt,
        pld.PriceListDetailId,
        s.PlacedDate
    from pld_grouped pld
    left join latest_sales s 
        on pld.ItemId = s.ItemId
        and pld.TradingPartnerId = s.TradingPartnerId
),

final as (
    select
        pld.FactSalesLineNumber,
        pld.ItemId,
        pld.SKU,
        pld.TradingPartnerName,
        pld.CurrentPLDPrice,
        pld.PriceStartAt,
        case
            when pld.PlacedDate < pld.PriceStartAt or pld.FactSalesLineNumber is null
                then ''No''
            else ''Yes''
        end as SOIsCurrent,
        pld.PriceListDetailId
    from pld_sales_joined pld
)

select * from final;
    ')

EXEC('
            SELECT * INTO "KNSDataWarehouse"."KNS"."CompletePLD__dbt_tmp" FROM "KNSDataWarehouse"."KNS"."CompletePLD__dbt_tmp__dbt_tmp_vw" 
    OPTION (LABEL = ''dbt-sqlserver'');

        ')

    
    EXEC('DROP VIEW IF EXISTS KNS.CompletePLD__dbt_tmp__dbt_tmp_vw')



    
    use [KNSDataWarehouse];
    if EXISTS (
        SELECT *
        FROM sys.indexes with (nolock)
        WHERE name = 'KNS_CompletePLD__dbt_tmp_cci'
        AND object_id=object_id('KNS_CompletePLD__dbt_tmp')
    )
    DROP index "KNS"."CompletePLD__dbt_tmp".KNS_CompletePLD__dbt_tmp_cci
    CREATE CLUSTERED COLUMNSTORE INDEX KNS_CompletePLD__dbt_tmp_cci
    ON "KNS"."CompletePLD__dbt_tmp"

   


  