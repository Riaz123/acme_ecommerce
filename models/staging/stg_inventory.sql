select
    "prodid" as "product_id",
    "purchase_price"
from {{ source('product_inventory', 'INVENTORY') }}
