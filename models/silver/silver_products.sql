-- models/silver/silver_products.sql

with deduped as (
    select
        *,
        row_number() over (partition by product_id order by dbt_valid_from desc) as rn
    from {{ ref('products_snapshot') }}
)

select
    product_id,
    product_name,
    product_category,
    product_cost,
    product_price,
    product_price - product_cost as product_profit
from deduped
where rn = 1