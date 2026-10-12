
{{ config(materialized='table') }}

WITH partner_source AS (
    SELECT DISTINCT INSURANCE_PARTNER
    FROM {{ ref('int_policies') }}
    WHERE INSURANCE_PARTNER IS NOT NULL
),

partner_dimension AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY INSURANCE_PARTNER
        ) AS PARTNER_SK,
        INSURANCE_PARTNER
    FROM partner_source
)

SELECT
    -1 AS PARTNER_SK,
    'UNKNOWN' AS INSURANCE_PARTNER

UNION ALL

SELECT
    PARTNER_SK,
    INSURANCE_PARTNER
FROM partner_dimension
