
{{ config(materialized='table') }}

WITH product_source AS (
    SELECT DISTINCT PRODUCT_TYPE
    FROM {{ ref('int_policies') }}
    WHERE PRODUCT_TYPE IS NOT NULL

    UNION

    SELECT DISTINCT PRODUCT_TYPE
    FROM {{ ref('int_leads') }}
    WHERE PRODUCT_TYPE IS NOT NULL
),

product_dimension AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY PRODUCT_TYPE
        ) AS PRODUCT_SK,
        PRODUCT_TYPE
    FROM product_source
)

SELECT
    -1 AS PRODUCT_SK,
    'UNKNOWN' AS PRODUCT_TYPE

UNION ALL

SELECT
    PRODUCT_SK,
    PRODUCT_TYPE
FROM product_dimension
