with unioned_orders as (
    select * from {{ source('transactional', 'ORDER_2023_Q1') }}
    union all
    select * from {{ source('transactional', 'ORDER_2023_Q2') }}
    union all
    select * from {{ source('transactional', 'ORDER_2023_Q3') }}
    union all
    select * from {{ source('transactional', 'ORDER_2023_Q4') }}
),
cleaned_orders as (
    select
        "transaction_id",
        "customer_id",
        "product_id",
        "quantity",
        "unit_price",
        "transaction_timestamp",
        "shipped_timestamp"
    from unioned_orders
    where "customer_id" is not null and trim("customer_id") != ''
)
select * from cleaned_orders
