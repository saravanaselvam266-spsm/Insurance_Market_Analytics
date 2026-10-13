
{{ config(
    materialized='table',
    schema='AUDIT'
) }}

WITH ranked_leads AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                QUOTE_DATE,
                PRODUCT_TYPE,
                CHANNEL,
                LEAD_SOURCE,
                STAGE1_FORM_SUBMITTED,
                STAGE1_DATE,
                STAGE2_OPTIONS_REVIEWED,
                STAGE2_DATE,
                ADVISOR_CONSULTED,
                STAGE3_DOCUMENTS_UPLOADED,
                STAGE3_DATE,
                POLICY_PURCHASED,
                PURCHASE_DATE,
                DROPOFF_REASON
            ORDER BY LEAD_ID
        ) AS DUPLICATE_RANK
    FROM {{ ref('stg_conversionfunnel') }}
)

SELECT
    *,
    'DQ28: Identical business details except for LEAD_ID'
        AS QUARANTINE_REASON
FROM ranked_leads
WHERE DUPLICATE_RANK > 1
