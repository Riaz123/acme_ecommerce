with products as (
    select * from {{ ref('stg_products') }}
),
forecast as (
    select * from {{ ref('stg_sales_forecast') }}
),
enriched as (
    select
        cast(p."product_id" as varchar) as "product_id",
        p."product_name",
        p."product_category",
        cast(f."month" as varchar) as "month",
        cast(f."forecast_sales" as number) as "forecast_sales",
        cast(f."forecast_profit" as float) as "forecast_profit"
    from forecast f
    left join products p on f."product_name" = p."product_name"
)
select * from enriched
