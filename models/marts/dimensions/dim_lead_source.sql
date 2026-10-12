
{{ config(materialized='table') }}

WITH source_values AS (
    SELECT DISTINCT LEAD_SOURCE
    FROM {{ ref('int_leads') }}
    WHERE LEAD_SOURCE IS NOT NULL
),

source_dimension AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY LEAD_SOURCE
        ) AS LEAD_SOURCE_SK,
        LEAD_SOURCE
    FROM source_values
)

SELECT
    -1 AS LEAD_SOURCE_SK,
    'UNKNOWN' AS LEAD_SOURCE

UNION ALL

SELECT
    LEAD_SOURCE_SK,
    LEAD_SOURCE
FROM source_dimension
