with source as (

    select * from {{ source('reference_data', 'country') }}

)

select * from source
