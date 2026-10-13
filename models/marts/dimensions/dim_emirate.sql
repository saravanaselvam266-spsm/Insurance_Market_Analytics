
{{ config(materialized='table') }}

WITH emirate_source AS (
    SELECT DISTINCT EMIRATE
    FROM {{ ref('int_policies') }}
    WHERE EMIRATE IS NOT NULL

    UNION

    SELECT DISTINCT EMIRATE
    FROM {{ ref('stg_customers') }}
    WHERE EMIRATE IS NOT NULL
),

emirate_dimension AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY EMIRATE
        ) AS EMIRATE_SK,
        EMIRATE
    FROM emirate_source
)

SELECT
    -1 AS EMIRATE_SK,
    'UNKNOWN' AS EMIRATE

UNION ALL

SELECT
    EMIRATE_SK,
    EMIRATE
FROM emirate_dimension
