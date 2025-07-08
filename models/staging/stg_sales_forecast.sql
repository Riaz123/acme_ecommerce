select
    "product" as "product_name",
    "month",
    "forecast_sales",
    "forecast_profit"
from {{ source('plan', 'SALES_FORECAST_2023') }}
