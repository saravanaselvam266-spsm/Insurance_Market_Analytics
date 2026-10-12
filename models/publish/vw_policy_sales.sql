
{{ config(materialized='view') }}

SELECT
    f.POLICY_ID,
    f.CUSTOMER_SK,
    c.CUSTOMER_ID,
    c.CUSTOMER_NAME,
    f.ADVISOR_SK,
    a.ADVISOR_ID,
    a.ADVISOR_NAME,
    p.PRODUCT_TYPE,
    pa.INSURANCE_PARTNER,
    sc.SALES_CHANNEL,
    e.EMIRATE,
    f.POLICY_STATUS,
    f.IS_CANCELLED,
    f.ISSUE_DATE,
    f.EXPIRY_DATE,
    f.PREMIUM_AMOUNT,
    f.GROSS_WRITTEN_PREMIUM,
    f.NET_WRITTEN_PREMIUM
FROM {{ ref('fact_policy') }} f
LEFT JOIN {{ ref('dim_customer') }} c
    ON f.CUSTOMER_SK = c.CUSTOMER_SK
LEFT JOIN {{ ref('dim_advisor') }} a
    ON f.ADVISOR_SK = a.ADVISOR_SK
LEFT JOIN {{ ref('dim_product') }} p
    ON f.PRODUCT_SK = p.PRODUCT_SK
LEFT JOIN {{ ref('dim_partner') }} pa
    ON f.PARTNER_SK = pa.PARTNER_SK
LEFT JOIN {{ ref('dim_sales_channel') }} sc
    ON f.SALES_CHANNEL_SK = sc.SALES_CHANNEL_SK
LEFT JOIN {{ ref('dim_emirate') }} e
    ON f.EMIRATE_SK = e.EMIRATE_SK
