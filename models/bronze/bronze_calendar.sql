-- models/bronze/bronze_calendar.sql
SELECT * FROM {{ source('MAVENDB', 'calendar') }}