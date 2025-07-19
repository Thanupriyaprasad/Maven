{% snapshot inventory_snapshot %}
{{
    config(
        target_schema='snapshots',
        unique_key=['store_id', 'product_id'],
        strategy='check',
        check_cols=['stock_on_hand']
    )
}}

SELECT
    store_id,
    product_id,
    stock_on_hand
FROM {{ source('MAVENDB', 'inventory') }}

{% endsnapshot %}