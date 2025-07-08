select transaction_id
from {{ ref('stg_orders') }}
where customer_id is null or trim(customer_id) = ''
