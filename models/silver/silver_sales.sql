with cleaned as (
    select
        cast(sale_id as integer) as sale_id,
        try_cast(date as date) as sale_date,
        cast(store_id as integer) as store_id,
        cast(product_id as integer) as product_id,
        cast(units as integer) as units
    from {{ source('MAVENDB', 'sales') }}
    where sale_id is not null
      and date is not null
      and store_id is not null
      and product_id is not null
      and units is not null
),

deduped as (
    select
        *,
        row_number() over (partition by sale_id order by sale_date) as rn
    from cleaned
)

select
    sale_id,
    sale_date,
    store_id,
    product_id,
    units,
    extract(year from sale_date) as year,
    extract(month from sale_date) as month
    
from deduped
where rn = 1