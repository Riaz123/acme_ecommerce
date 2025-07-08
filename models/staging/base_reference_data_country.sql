with source as (
        select * from {{ source('reference_data', 'country') }}
  ),
  renamed as (
      select
          {{ adapter.quote("alpha_3_country_code") }},
        {{ adapter.quote("country") }},
        {{ adapter.quote("region") }},
        {{ adapter.quote("active_flag") }}

      from source
  )
  select * from renamed
    