with source as (

    select * from {{ source('product_inventory', 'inventory') }}

)

select * from source
