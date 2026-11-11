with users as (
    select * from {{ ref('stg_sql_server_dbo__users') }}
),

cleaned as (
    select
          user_id
        , first_name
        , last_name
        , lower(trim(email))                      as email
        , phone_number
        , address_id
        , created_at_utc
        , updated_at_utc
        , date_load
    from users
    where not is_deleted
    qualify row_number() over (partition by user_id order by date_load desc) = 1
)


select * from cleaned