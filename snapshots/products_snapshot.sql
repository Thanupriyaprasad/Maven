{% snapshot products_snapshot %}
  {{
    config(
      target_schema='snapshots',  -- or your preferred schema for snapshots
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
  FROM {{ ref('bronze_products') }}  -- or use the actual reference if you load raw tables as models/views
{% endsnapshot %}