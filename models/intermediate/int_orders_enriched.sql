with orders as (
    select * from {{ ref('stg_orders') }}
),
customers as (
    select * from {{ ref('stg_customers') }}
),
products as (
    select * from {{ ref('stg_products') }}
),
countries as (
    select * from {{ ref('stg_countries') }}
),
enriched as (
    select
        o."transaction_id",
        o."transaction_timestamp",
        o."shipped_timestamp",
        o."customer_id",
        c."email",
        c."first_name",
        c."last_name",
        c."iso_country_code",
        co."country",
        co."region",
        o."product_id",
        p."product_name",
        p."product_category",
        o."quantity",
        o."unit_price",
        o."quantity" * o."unit_price" as "order_value"
    from orders o
    left join customers c on o."customer_id" = c."customer_id"
    left join products p on o."product_id" = p."product_id"
    left join countries co on c."iso_country_code" = co."iso_country_code"
    where c."customer_id" is not null
)
select * from enriched
