with cleaned as (
    select
        trim(C1) as table_name,
        trim(C2) as field_name,
        trim(C3) as description
    from {{ source('MAVENDB', 'dictionary') }}
    
    where lower(trim(C1)) != 'table'
      and lower(trim(C2)) != 'field'
      and lower(trim(C3)) != 'description'
),

deduped as (
    select
        *,
        row_number() over (partition by lower(table_name), lower(field_name) order by description desc) as rn
    from cleaned
)

select
    lower(table_name) as table_name,
    lower(field_name) as field_name,
    description,
    lower(table_name) || '__' || lower(field_name) as table_field_key,
    case when description is not null and length(trim(description)) > 0 then 1 else 0 end as has_description
from deduped
where rn = 1