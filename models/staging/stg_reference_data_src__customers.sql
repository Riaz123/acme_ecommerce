with source as (

    select * from {{ source('reference_data', 'customer') }}

)

select * from source
