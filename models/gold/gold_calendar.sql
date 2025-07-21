with base as (
    select
        cast(calendar_date as date) as date_actual
    from MAVENDB.PUBLIC.silver_calendar
),

enriched as (
    select
        date_actual,
        extract(year from date_actual) as year,
        extract(month from date_actual) as month,
        extract(day from date_actual) as day,
        extract(quarter from date_actual) as quarter,
        extract(week from date_actual) as week_of_year,
        extract(dow from date_actual) + 1 as day_of_week,
        to_char(date_actual, 'Day') as day_name,
        to_char(date_actual, 'Month') as month_name,
        case when extract(dow from date_actual) in (5, 6) then 1 else 0 end as is_weekend,
        case when date_actual = date_trunc('month', date_actual) then 1 else 0 end as is_month_start,
        case when date_actual = last_day(date_actual, 'month') then 1 else 0 end as is_month_end
    from base
)

select * from enriched
order by date_actual