
{{ config(materialized='table') }}

WITH advisor_source AS (
    SELECT DISTINCT
        ADVISOR_ID,
        ADVISOR_NAME,
        TEAM,
        JOIN_DATE,
        TARGET_POLICIES,
        TARGET_REVENUE
    FROM {{ ref('stg_advisors') }}
    WHERE ADVISOR_ID IS NOT NULL
),

advisor_dimension AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY ADVISOR_ID
        ) AS ADVISOR_SK,
        ADVISOR_ID,
        ADVISOR_NAME,
        TEAM,
        JOIN_DATE,
        TARGET_POLICIES,
        TARGET_REVENUE
    FROM advisor_source
)

SELECT
    -1 AS ADVISOR_SK,
    'UNKNOWN' AS ADVISOR_ID,
    'Unknown Advisor' AS ADVISOR_NAME,
    'Unknown' AS TEAM,
    NULL AS JOIN_DATE,
    NULL AS TARGET_POLICIES,
    NULL AS TARGET_REVENUE

UNION ALL

SELECT
    ADVISOR_SK,
    ADVISOR_ID,
    ADVISOR_NAME,
    TEAM,
    JOIN_DATE,
    TARGET_POLICIES,
    TARGET_REVENUE
FROM advisor_dimension
