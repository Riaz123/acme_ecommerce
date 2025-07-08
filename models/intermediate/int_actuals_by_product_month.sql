with orders as (
    select * from {{ ref('stg_orders') }}
),
products as (
    select * from {{ ref('stg_products') }}
),
inventory as (
    select * from {{ ref('stg_inventory') }}
),
enriched as (
    select
        cast(o."product_id" as varchar) as "product_id",
        p."product_name",
        p."product_category",
        to_char(to_timestamp(o."transaction_timestamp", 'DD/MM/YYYY HH24:MI'), 'YYYY-MM') as "month",
        cast(sum(o."quantity") as number) as "actual_sales",
        cast(sum(o."quantity" * o."unit_price") as float) as "actual_revenue",
        cast(sum(o."quantity" * i."purchase_price") as float) as "actual_cost",
        cast(sum(o."quantity" * o."unit_price") - sum(o."quantity" * i."purchase_price") as float) as "actual_profit"
    from orders o
    left join products p on o."product_id" = p."product_id"
    left join inventory i on o."product_id" = i."product_id"
    group by
        o."product_id", p."product_name", p."product_category",
        to_char(to_timestamp(o."transaction_timestamp", 'DD/MM/YYYY HH24:MI'), 'YYYY-MM')
)
select * from enriched
