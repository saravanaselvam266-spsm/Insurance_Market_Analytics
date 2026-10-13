
{{ config(materialized='table') }}

WITH date_range AS (
    SELECT DATEADD(
        DAY,
        SEQ4(),
        '2020-01-01'::DATE
    ) AS FULL_DATE
    FROM TABLE(GENERATOR(ROWCOUNT => 2557))
),

date_dimension AS (
    SELECT
        TO_NUMBER(TO_CHAR(FULL_DATE, 'YYYYMMDD')) AS DATE_SK,
        FULL_DATE,
        YEAR(FULL_DATE) AS YEAR,
        QUARTER(FULL_DATE) AS QUARTER,
        MONTH(FULL_DATE) AS MONTH,
        MONTHNAME(FULL_DATE) AS MONTH_NAME,
        DAY(FULL_DATE) AS DAY,
        DAYOFWEEKISO(FULL_DATE) AS DAY_OF_WEEK,
        DAYNAME(FULL_DATE) AS DAY_NAME
    FROM date_range
)

SELECT
    -1 AS DATE_SK,
    NULL::DATE AS FULL_DATE,
    NULL::NUMBER AS YEAR,
    NULL::NUMBER AS QUARTER,
    NULL::NUMBER AS MONTH,
    'Unknown' AS MONTH_NAME,
    NULL::NUMBER AS DAY,
    NULL::NUMBER AS DAY_OF_WEEK,
    'Unknown' AS DAY_NAME

UNION ALL

SELECT
    DATE_SK,
    FULL_DATE,
    YEAR,
    QUARTER,
    MONTH,
    MONTH_NAME,
    DAY,
    DAY_OF_WEEK,
    DAY_NAME
FROM date_dimension
