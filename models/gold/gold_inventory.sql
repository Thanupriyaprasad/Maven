with base as (
    select
        store_id,
        product_id,
        stock_on_hand
    from {{ ref('silver_inventory') }} 
),


store_summary as (
    select
        store_id,
        sum(stock_on_hand) as total_stock_in_store
    from base
    group by store_id
),


product_summary as (
    select
        product_id,
        sum(stock_on_hand) as total_stock_for_product
    from base
    group by product_id
),


ranked as (
    select
        *,
        rank() over (partition by store_id order by stock_on_hand desc) as product_stock_rank_in_store
    from base
)

select
    r.store_id,
    r.product_id,
    r.stock_on_hand,
    case when r.stock_on_hand = 0 then 1 else 0 end as is_out_of_stock,
    s.total_stock_in_store,
    p.total_stock_for_product,
    r.product_stock_rank_in_store
from ranked r
left join store_summary s on r.store_id = s.store_id
left join product_summary p on r.product_id = p.product_id
order by r.store_id, r.product_stock_rank_in_store