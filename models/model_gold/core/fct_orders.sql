with orders as (
    select * from {{ ref('slv_sql_server_dbo__orders') }}
),

final as (
    select
        order_id, 
        user_id,
        address_id,
        promo_id,
        created_at_utc                    as order_at_utc,                          
        ESTIMATED_DELIVERY_AT,
        delivered_at,
        tracking_id,
        shipping_service,
        shipping_cost,
        order_cost_usd,                           
        order_total,
        status,
        is_deleted,  
        date_load
    from orders
)

select * from final
