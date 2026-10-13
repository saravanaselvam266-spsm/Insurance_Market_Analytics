
{{ config(materialized='table') }}

WITH customer_source AS (
    SELECT DISTINCT
        CUSTOMER_ID,
        CUSTOMER_NAME,
        AGE,
        GENDER,
        EMIRATE,
        CUSTOMER_SEGMENT,
        REGISTRATION_DATE,
        MYALFRED_MEMBER,
        CUSTOMER_RATING
    FROM {{ ref('stg_customers') }}
    WHERE CUSTOMER_ID IS NOT NULL
),

customer_dimension AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY CUSTOMER_ID
        ) AS CUSTOMER_SK,
        CUSTOMER_ID,
        CUSTOMER_NAME,
        AGE,
        GENDER,
        EMIRATE,
        CUSTOMER_SEGMENT,
        REGISTRATION_DATE,
        MYALFRED_MEMBER,
        CUSTOMER_RATING
    FROM customer_source
)

SELECT
    -1 AS CUSTOMER_SK,
    'UNKNOWN' AS CUSTOMER_ID,
    'Unknown Customer' AS CUSTOMER_NAME,
    NULL AS AGE,
    'Unknown' AS GENDER,
    'Unknown' AS EMIRATE,
    'Unknown' AS CUSTOMER_SEGMENT,
    NULL AS REGISTRATION_DATE,
    NULL AS MYALFRED_MEMBER,
    NULL AS CUSTOMER_RATING

UNION ALL

SELECT
    CUSTOMER_SK,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    AGE,
    GENDER,
    EMIRATE,
    CUSTOMER_SEGMENT,
    REGISTRATION_DATE,
    MYALFRED_MEMBER,
    CUSTOMER_RATING
FROM customer_dimension
