
-- =============================================================================
-- int_events__pivoted_by_session
-- =============================================================================

{% set event_types = [
    'page_view',
    'add_to_cart',
    'checkout',
    'package_shipped'
] %}

with events as (
    select * from {{ ref('slv_sql_server_dbo__events') }}
),

pivoted as (
    select
          user_id
        , session_id
        {%- for event_type in event_types %}
        , sum(case
            when event_type = '{{ event_type }}' then 1
            else 0
          end) as {{ event_type }}_count
        {%- endfor %}
        , min(created_at_utc) as session_start_at_utc
        , max(created_at_utc) as session_end_at_utc
        , datediff(
            'second',
            min(created_at_utc),
            max(created_at_utc)
          ) as session_duration_seconds
    from events
    group by user_id, session_id
)

select * from pivoted
