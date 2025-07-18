{% snapshot products_snapshot %}
{{
    config(
        target_schema='snapshots',
        unique_key='product_id',
        strategy='check',
        check_cols=['product_name', 'product_category', 'product_cost', 'product_price']
    )
}}
SELECT
    product_id,
    product_name,
    product_category,
    product_cost,
    product_price
FROM {{ source('MAVENDB', 'PRODUCTS') }}
{% endsnapshot %}