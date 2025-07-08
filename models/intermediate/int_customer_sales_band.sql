with sales as (
    select
        "customer_id",
        sum("order_value") as total_sales
    from {{ ref('int_orders_enriched') }}
    group by "customer_id"
),
banded as (
    select
        "customer_id",
        total_sales,
        case
            when total_sales <= 1000 then '$0-1000'
            when total_sales <= 5000 then '$1001-5000'
            else '$5000+'
        end as sales_band
    from sales
)
select * from banded
