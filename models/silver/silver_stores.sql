with cleaned as (
    select
        cast(store_id as integer) as store_id,
        trim(store_name) as store_name,
        trim(store_city) as store_city,
        trim(store_location) as store_location,
        try_cast(store_open_date as date) as store_open_date
    from {{ source('MAVENDB', 'stores') }}
    where store_id is not null
      and store_name is not null
      and store_city is not null
      and store_location is not null
      and store_open_date is not null
),

deduped as (
    select
        *,
        row_number() over (partition by store_id order by store_open_date) as rn
    from cleaned
)

select
    store_id,
    store_name,
    store_city,
    store_location,
    store_open_date,
    extract(year from store_open_date) as open_year,
    extract(month from store_open_date) as open_month
from deduped
where rn = 1