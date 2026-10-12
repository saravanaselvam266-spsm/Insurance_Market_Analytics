
{{ config(materialized='table') }}

WITH channel_source AS (
    SELECT DISTINCT SALES_CHANNEL
    FROM {{ ref('int_policies') }}
    WHERE SALES_CHANNEL IS NOT NULL

    UNION

    SELECT DISTINCT CHANNEL AS SALES_CHANNEL
    FROM {{ ref('int_leads') }}
    WHERE CHANNEL IS NOT NULL
),

channel_dimension AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY SALES_CHANNEL
        ) AS SALES_CHANNEL_SK,
        SALES_CHANNEL
    FROM channel_source
)

SELECT
    -1 AS SALES_CHANNEL_SK,
    'UNKNOWN' AS SALES_CHANNEL

UNION ALL

SELECT
    SALES_CHANNEL_SK,
    SALES_CHANNEL
FROM channel_dimension
