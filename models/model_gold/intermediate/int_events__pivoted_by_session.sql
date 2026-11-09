-- =============================================================================
-- int_events__pivoted_by_session
-- =============================================================================
-- Pivota los eventos: una fila por (user_id, session_id) con un contador por
-- tipo de evento. En esta versión los tipos están escritos a mano; el día 4 los
-- obtendremos de los datos con una macro (obtener_valores).
-- =============================================================================
with events as (
    select * from {{ ref('slv_sql_server_dbo__events') }}
),

pivoted as (
    select
          user_id
        , session_id
        {%- for event_type in event_types %}
        , sum(case when event_type = '{{ event_type }}' then 1 else 0 end) as {{ event_type }}_count
        {%- endfor %}
        , min(created_at_utc)                                           as session_start_at_utc
        , max(created_at_utc)                                           as session_end_at_utc
        , datediff('second', min(created_at_utc), max(created_at_utc))  as session_duration_seconds
    from events
    group by user_id, session_id
)

select * from pivoted