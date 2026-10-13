
{{ config(materialized='table') }}

SELECT
    l.LEAD_ID,

    COALESCE(ds.LEAD_SOURCE_SK, -1) AS LEAD_SOURCE_SK,
    COALESCE(dp.PRODUCT_SK, -1) AS PRODUCT_SK,
    COALESCE(dsc.SALES_CHANNEL_SK, -1) AS SALES_CHANNEL_SK,

    COALESCE(dq.DATE_SK, -1) AS QUOTE_DATE_KEY,
    COALESCE(d1.DATE_SK, -1) AS STAGE1_DATE_KEY,
    COALESCE(d2.DATE_SK, -1) AS STAGE2_DATE_KEY,
    COALESCE(d3.DATE_SK, -1) AS STAGE3_DATE_KEY,
    COALESCE(d4.DATE_SK, -1) AS PURCHASE_DATE_KEY,

    l.STAGE1_FORM_SUBMITTED,
    l.STAGE2_OPTIONS_REVIEWED,
    l.ADVISOR_CONSULTED,
    l.STAGE3_DOCUMENTS_UPLOADED,
    l.POLICY_PURCHASED,

    DATEDIFF(DAY, l.QUOTE_DATE, l.PURCHASE_DATE)
        AS DAYS_TO_PURCHASE,

    CASE
        WHEN l.STAGE2_DATE < l.STAGE1_DATE
          OR l.STAGE3_DATE < l.STAGE2_DATE
          OR l.PURCHASE_DATE < l.STAGE3_DATE
        THEN 1
        ELSE 0
    END AS DQ_STAGE_SEQUENCE_FLAG,

    l.DROPOFF_REASON

FROM {{ ref('int_leads') }} l

LEFT JOIN {{ ref('dim_lead_source') }} ds
    ON l.LEAD_SOURCE = ds.LEAD_SOURCE

LEFT JOIN {{ ref('dim_product') }} dp
    ON l.PRODUCT_TYPE = dp.PRODUCT_TYPE

LEFT JOIN {{ ref('dim_sales_channel') }} dsc
    ON l.CHANNEL = dsc.SALES_CHANNEL

LEFT JOIN {{ ref('dim_date') }} dq
    ON l.QUOTE_DATE = dq.FULL_DATE

LEFT JOIN {{ ref('dim_date') }} d1
    ON l.STAGE1_DATE = d1.FULL_DATE

LEFT JOIN {{ ref('dim_date') }} d2
    ON l.STAGE2_DATE = d2.FULL_DATE

LEFT JOIN {{ ref('dim_date') }} d3
    ON l.STAGE3_DATE = d3.FULL_DATE

LEFT JOIN {{ ref('dim_date') }} d4
    ON l.PURCHASE_DATE = d4.FULL_DATE
