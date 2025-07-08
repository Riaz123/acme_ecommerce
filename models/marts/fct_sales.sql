with orders as (
    select * from {{ ref('int_orders_enriched') }}
),
bands as (
    select * from {{ ref('int_customer_sales_band') }}
)
select
    o."transaction_id",
    o."transaction_timestamp" as transaction_date,
    TO_CHAR(TO_TIMESTAMP(o."transaction_timestamp", 'DD/MM/YYYY HH24:MI'), 'YYYY-MM') as transaction_month,
    TO_CHAR(TO_TIMESTAMP(o."transaction_timestamp", 'DD/MM/YYYY HH24:MI'), 'YYYY-"Q"Q') as transaction_quarter,
    TO_CHAR(TO_TIMESTAMP(o."transaction_timestamp", 'DD/MM/YYYY HH24:MI'), 'YYYY') as transaction_year,
    o."shipped_timestamp" as shipped_date,
    TO_CHAR(TO_TIMESTAMP(o."shipped_timestamp", 'DD/MM/YYYY HH24:MI'), 'YYYY-MM') as shipped_month,
    TO_CHAR(TO_TIMESTAMP(o."shipped_timestamp", 'DD/MM/YYYY HH24:MI'), 'YYYY-"Q"Q') as shipped_quarter,
    TO_CHAR(TO_TIMESTAMP(o."shipped_timestamp", 'DD/MM/YYYY HH24:MI'), 'YYYY') as shipped_year,
    o."product_name",
    o."product_category",
    o."first_name" || ' ' || o."last_name" as customer_name,
    o."email" as customer_email_address,
    o."country" as customer_country,
    o."region" as customer_region,
    b.sales_band as customer_sales_band,
    o."quantity" as order_quantity,
    o."order_value" as order_value
from orders o
left join bands b on o."customer_id" = b."customer_id"
