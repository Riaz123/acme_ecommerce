with base as (
    select
        "customer code" as "customer_id",
        "email address" as "email",
        "first name" as "first_name",
        "last name" as "last_name",
        "iso country code" as "iso_country_code"
    from {{ source('reference_data', 'CUSTOMER') }}
),
valid_emails as (
    select *
    from base
    where {{ validate_email('"email"') }}
)
select * from valid_emails
