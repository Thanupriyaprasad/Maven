SELECT
    DATE AS calendar_date,
    EXTRACT(YEAR FROM DATE) AS year,
    EXTRACT(MONTH FROM DATE) AS month,
    EXTRACT(DAY FROM DATE) AS day,
    EXTRACT(DAYOFWEEK FROM DATE) AS weekday_number,       -- 1=Sunday, 7=Saturday
    TO_VARCHAR(TO_CHAR(DATE, 'DAY')) AS weekday_name,
    TO_VARCHAR(TO_CHAR(DATE, 'MONTH')) AS month_name
FROM {{ ref('bronze_calendar') }}
WHERE DATE IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY DATE ORDER BY DATE) = 1  -- Remove duplicate dates if any