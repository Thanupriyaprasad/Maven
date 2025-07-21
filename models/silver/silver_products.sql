

with deduped as (
    select
        *,
        row_number() over (partition by product_id order by dbt_valid_from desc) as rn
    from {{ ref('products_snapshot') }}
),

cleaned as (
    select
        product_id,
        product_name,
        product_category,
        
        cast(replace(product_cost, '$', '') as decimal(10,2)) as product_cost,
        cast(replace(product_price, '$', '') as decimal(10,2)) as product_price
    from deduped
    where rn = 1
)

select
    product_id,
    product_name,
    product_category,
    product_cost,
    product_price,
    product_price - product_cost as product_profit
from cleaned