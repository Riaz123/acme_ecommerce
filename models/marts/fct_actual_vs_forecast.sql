/** with actuals as (
    select * from {{ ref('int_actuals_by_product_month') }}
),
forecast as (
    select * from {{ ref('int_forecast_by_product_month') }}
),
final as (
    select
        coalesce(a."product_id", f."product_id") as "product_id",
        coalesce(a."product_name", f."product_name") as "product_name",
        coalesce(a."product_category", f."product_category") as "product_category",
        coalesce(a."month", f."month") as "month",
        a."actual_sales",
        a."actual_revenue",
        a."actual_cost",
        a."actual_profit",
        f."forecast_sales",
        f."forecast_profit"
    from actuals a
    full outer join forecast f
        on a."product_id" = f."product_id"
        and a."month" = f."month"
)
select
    *,
    to_char(to_date("month", 'YYYY-MM'), 'YYYY-"Q"Q') as "quarter",
    to_char(to_date("month", 'YYYY-MM'), 'YYYY') as "year"
from final
**/

with actuals as (
    select
        "product_id",
        "product_name",
        "product_category",
        "month",
        "actual_sales",
        "actual_revenue",
        "actual_cost",
        "actual_profit"
    from {{ ref('int_actuals_by_product_month') }}
),
forecast as (
    select
        "product_id",
        "product_name",
        "product_category",
        "month",
        "forecast_sales",
        "forecast_profit"
    from {{ ref('int_forecast_by_product_month') }}
),
final as (
    select
        coalesce(a."product_id", f."product_id") as "product_id",
        coalesce(a."product_name", f."product_name") as "product_name",
        coalesce(a."product_category", f."product_category") as "product_category",
        coalesce(a."month", f."month") as "month",
        a."actual_sales",
        a."actual_revenue",
        a."actual_cost",
        a."actual_profit",
        f."forecast_sales",
        f."forecast_profit"
    from actuals a
    full outer join forecast f
        on a."product_id" = f."product_id"
        and a."month" = f."month"
)
select
    "product_id",
    "product_name",
    "product_category",
    "month",
    "actual_sales",
    "actual_revenue",
    "actual_cost",
    "actual_profit",
    "forecast_sales",
    "forecast_profit",
    to_char(to_date("month", 'YYYY-MM'), 'YYYY-"Q"Q') as "quarter",
    to_char(to_date("month", 'YYYY-MM'), 'YYYY') as "year"
from final
