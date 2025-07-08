with source as (

    select * from {{ source('transactional_orders', 'order_2023_q1') }}

)

select * from source
