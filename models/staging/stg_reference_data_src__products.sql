with source as (

    select * from {{ source('reference_data', 'product') }}

)

select * from source
