
{{ config(materialized='table') }}

SELECT
    p.POLICY_ID,

    COALESCE(c.CUSTOMER_SK, -1) AS CUSTOMER_SK,
    COALESCE(a.ADVISOR_SK, -1) AS ADVISOR_SK,
    COALESCE(pr.PRODUCT_SK, -1) AS PRODUCT_SK,
    COALESCE(pa.PARTNER_SK, -1) AS PARTNER_SK,
    COALESCE(sc.SALES_CHANNEL_SK, -1) AS SALES_CHANNEL_SK,
    COALESCE(e.EMIRATE_SK, -1) AS EMIRATE_SK,
    COALESCE(d.DATE_SK, -1) AS ISSUE_DATE_KEY,

    p.PREMIUM_AMOUNT,
    p.GROSS_WRITTEN_PREMIUM,
    p.NET_WRITTEN_PREMIUM,
    p.POLICY_STATUS,
    p.IS_CANCELLED,
    p.ISSUE_DATE,
    p.EXPIRY_DATE,
    p.CUSTOMER_ID,
    p.ADVISOR_ID

FROM {{ ref('int_policies') }} p

LEFT JOIN {{ ref('dim_customer') }} c
    ON p.CUSTOMER_ID = c.CUSTOMER_ID

LEFT JOIN {{ ref('dim_advisor') }} a
    ON p.ADVISOR_ID = a.ADVISOR_ID

LEFT JOIN {{ ref('dim_product') }} pr
    ON p.PRODUCT_TYPE = pr.PRODUCT_TYPE

LEFT JOIN {{ ref('dim_partner') }} pa
    ON p.INSURANCE_PARTNER = pa.INSURANCE_PARTNER

LEFT JOIN {{ ref('dim_sales_channel') }} sc
    ON p.SALES_CHANNEL = sc.SALES_CHANNEL

LEFT JOIN {{ ref('dim_emirate') }} e
    ON p.EMIRATE = e.EMIRATE

LEFT JOIN {{ ref('dim_date') }} d
    ON p.ISSUE_DATE = d.FULL_DATE
