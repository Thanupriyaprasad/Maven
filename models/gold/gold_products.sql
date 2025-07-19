with products as (
    select
        product_id,
        product_name,
        product_category,
        product_price,
        product_cost,
        (product_price - product_cost) as product_profit
    from {{ ref('silver_products') }}
),

sales_summary as (
    select
        product_id,
        sum(units) as total_units_sold
    from {{ ref('gold_sales') }}
    group by product_id
)

select
    p.product_id,
    p.product_name,
    p.product_category,
    p.product_price,
    p.product_cost,
    p.product_profit,
    coalesce(s.total_units_sold, 0) as total_units_sold,
    coalesce(s.total_units_sold, 0) * p.product_price as total_sales_revenue
from products p
left join sales_summary s on p.product_id = s.product_id
order by total_units_sold desc