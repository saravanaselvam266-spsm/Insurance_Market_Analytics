
{{ config(materialized='table') }}

SELECT
    COALESCE(dc.CAMPAIGN_SK, -1) AS CAMPAIGN_SK,
    COALESCE(dd.DATE_SK, -1) AS START_DATE_KEY,

    c.CAMPAIGN_ID,
    c.BUDGET,
    c.ACTUAL_SPEND,
    c.LEADS_GENERATED,
    c.CONVERSIONS,
    c.IMPRESSIONS,
    c.CLICKS,

    CASE
        WHEN c.LEADS_GENERATED > 0
        THEN c.ACTUAL_SPEND / c.LEADS_GENERATED
        ELSE NULL
    END AS COST_PER_LEAD,

    CASE
        WHEN c.LEADS_GENERATED > 0
        THEN c.CONVERSIONS * 100.0 / c.LEADS_GENERATED
        ELSE 0
    END AS CONVERSION_RATE_PERCENT

FROM {{ ref('stg_campaigns') }} c

LEFT JOIN {{ ref('dim_campaign') }} dc
    ON c.CAMPAIGN_ID = dc.CAMPAIGN_ID

LEFT JOIN {{ ref('dim_date') }} dd
    ON c.START_DATE = dd.FULL_DATE
