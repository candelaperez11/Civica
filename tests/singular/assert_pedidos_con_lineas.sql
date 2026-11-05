
with orders as (
    select * from {{ ref('fct_orders') }} 
),
order_items as (
    select * from {{ ref('fct_order_items') }} 
)

select
    o.*
from orders o 
    left join order_items i 
    on o.order_id = i.order_id