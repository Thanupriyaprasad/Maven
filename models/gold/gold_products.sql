with products as (
    select
        product_id,
        product_name,
        product_category,
        product_price,
        product_cost,
        product_profit  
    from {{ ref('silver_products') }}
),


sales_summary as (
    select
        product_id,
        sum(units) as total_units_sold,
        sum(units * sale_price) as total_sales_revenue
    from {{ ref('gold_sales') }}
    group by product_id
),


inventory_summary as (
    select
        product_id,
        sum(stock_on_hand) as total_stock_on_hand
    from {{ ref('gold_inventory') }}
    group by product_id
)

select
    p.product_id,
    p.product_name,
    p.product_category,
    p.product