
{{ config(materialized='table') }}

WITH campaign_source AS (
    SELECT DISTINCT
        CAMPAIGN_ID,
        CAMPAIGN_NAME,
        CHANNEL,
        START_DATE,
        END_DATE,
        BUDGET,
        ACTUAL_SPEND,
        LEADS_GENERATED,
        CONVERSIONS,
        IMPRESSIONS,
        CLICKS
    FROM {{ ref('stg_campaigns') }}
    WHERE CAMPAIGN_ID IS NOT NULL
),

campaign_dimension AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY CAMPAIGN_ID
        ) AS CAMPAIGN_SK,
        CAMPAIGN_ID,
        CAMPAIGN_NAME,
        CHANNEL,
        START_DATE,
        END_DATE,
        BUDGET,
        ACTUAL_SPEND,
        LEADS_GENERATED,
        CONVERSIONS,
        IMPRESSIONS,
        CLICKS
    FROM campaign_source
)

SELECT
    -1 AS CAMPAIGN_SK,
    'UNKNOWN' AS CAMPAIGN_ID,
    'Unknown Campaign' AS CAMPAIGN_NAME,
    'UNKNOWN' AS CHANNEL,
    NULL AS START_DATE,
    NULL AS END_DATE,
    NULL AS BUDGET,
    NULL AS ACTUAL_SPEND,
    NULL AS LEADS_GENERATED,
    NULL AS CONVERSIONS,
    NULL AS IMPRESSIONS,
    NULL AS CLICKS

UNION ALL

SELECT
    CAMPAIGN_SK,
    CAMPAIGN_ID,
    CAMPAIGN_NAME,
    CHANNEL,
    START_DATE,
    END_DATE,
    BUDGET,
    ACTUAL_SPEND,
    LEADS_GENERATED,
    CONVERSIONS,
    IMPRESSIONS,
    CLICKS
FROM campaign_dimension
