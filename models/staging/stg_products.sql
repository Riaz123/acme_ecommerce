select
    "prodid" as "product_id",
    "prodname" as "product_name",
    "prodcat" as "product_category"
from {{ source('reference_data', 'product') }}
