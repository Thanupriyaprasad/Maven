with base as (
    select
        store_id,
        store_name,
        store_city,
        store_location,
        store_open_date,
        extract(year from store_open_date) as open_year,
        extract(month from store_open_date) as open_month
    from {{ ref('silver_stores') }}
),


today as (
    select current_date() as today
),

enriched as (
    select
        b.*,
        datediff(year, b.store_open_date, t.today) as store_age_years,
        datediff(month, b.store_open_date, t.today) as store_age_months,
        case
            when b.store_open_date < '2000-01-01' then 'Legacy'
            when b.store_open_date >= dateadd(year, -5, t.today) then 'New'
            else 'Standard'
        end as store_age_category
    from base b
    cross join today t
),


city_summary as (
    select
        store_city,
        count(*) as stores_in_city
    from base
    group by store_city
),


location_summary as (
    select
        store_location,
        count(*) as stores_in_location
    from base
    group by store_location
)

select
    e.store_id,
    e.store_name,
    e.store_city,
    e.store_location,
    e.store_open_date,
    e.open_year,
    e.open_month,
    e.store_age_years,
    e.store_age_months,
    e.store_age_category,
    c.stores_in_city,
    l.stores_in_location
from enriched e
left join city_summary c on e.store_city = c.store_city
left join location_summary l on e.store_location = l.store_location
order by e.store_id