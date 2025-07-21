with base as (
    select
        table_name,
        field_name,
        description,
        table_field_key,
        has_description
    from {{ ref('silver_dictionary') }}
),

table_stats as (
    select
        table_name,
        count(*) as total_fields,
        sum(has_description) as fields_with_description,
        round(100.0 * sum(has_description) / count(*), 1) as pct_described
    from base
    group by table_name
)

select
    b.table_name,
    b.field_name,
    b.description,
    b.table_field_key,
    b.has_description,
    t.total_fields,
    t.fields_with_description,
    t.pct_described
from base b
join table_stats t
  on b.table_name = t.table_name
order by t.pct_described desc, b.table_name, b.field_name