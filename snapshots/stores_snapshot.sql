{% snapshot stores_snapshot %}
{{
    config(
        target_schema='snapshots',
        unique_key='store_id',
        strategy='check',
        check_cols=['store_name', 'store_city', 'store_location', 'store_open_date']
    )
}}
SELECT
    store_id,
    store_name,
    store_city,
    store_location,
    store_open_date
FROM {{ source('MAVENDB', 'stores') }}
{% endsnapshot %}