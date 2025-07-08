-- If column is lowercase and quoted in Snowflake
select
    "alpha_3_country_code" as "iso_country_code",
    "country",
    "region",
    "active_flag"
from {{ source('reference_data', 'COUNTRY') }}
where "active_flag" = 'Y'
