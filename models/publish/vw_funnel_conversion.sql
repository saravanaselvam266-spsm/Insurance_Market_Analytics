
{{ config(materialized='view') }}

SELECT
    f.LEAD_ID,
    ls.LEAD_SOURCE,
    p.PRODUCT_TYPE,
    sc.SALES_CHANNEL,

    dq.FULL_DATE AS QUOTE_DATE,

    d1.FULL_DATE AS STAGE1_DATE,
    d2.FULL_DATE AS STAGE2_DATE,
    d3.FULL_DATE AS STAGE3_DATE,
    d4.FULL_DATE AS PURCHASE_DATE,

    f.STAGE1_FORM_SUBMITTED,
    f.STAGE2_OPTIONS_REVIEWED,
    f.ADVISOR_CONSULTED,
    f.STAGE3_DOCUMENTS_UPLOADED,
    f.POLICY_PURCHASED,

    f.DAYS_TO_PURCHASE,
    f.DQ_STAGE_SEQUENCE_FLAG,
    f.DROPOFF_REASON

FROM {{ ref('fact_lead_funnel') }} f

LEFT JOIN {{ ref('dim_lead_source') }} ls
    ON f.LEAD_SOURCE_SK = ls.LEAD_SOURCE_SK

LEFT JOIN {{ ref('dim_product') }} p
    ON f.PRODUCT_SK = p.PRODUCT_SK

LEFT JOIN {{ ref('dim_sales_channel') }} sc
    ON f.SALES_CHANNEL_SK = sc.SALES_CHANNEL_SK

LEFT JOIN {{ ref('dim_date') }} dq
    ON f.QUOTE_DATE_KEY = dq.DATE_SK

LEFT JOIN {{ ref('dim_date') }} d1
    ON f.STAGE1_DATE_KEY = d1.DATE_SK

LEFT JOIN {{ ref('dim_date') }} d2
    ON f.STAGE2_DATE_KEY = d2.DATE_SK

LEFT JOIN {{ ref('dim_date') }} d3
    ON f.STAGE3_DATE_KEY = d3.DATE_SK

LEFT JOIN {{ ref('dim_date') }} d4
    ON f.PURCHASE_DATE_KEY = d4.DATE_SK
