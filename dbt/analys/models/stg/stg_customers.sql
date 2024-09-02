WITH customers AS (
    SELECT 
        CAST(customer_id AS INT64) as customer_id
        , CAST(sale_id AS INT64) as sale_id
        , names as customer_names
        , genders as customer_genders
        , SAFE_CAST(NULLIF(emails, '') AS STRING) as customer_emails
        , {{ normalize_phone_number('customers.phones') }} as normalized_phone
        , addres as customer_address
        , SAFE_CAST(NULLIF(regions, '') AS STRING) as region
    FROM {{ source('dreamshop_raw', 'customers') }}
)
SELECT
    customer_id
    , sale_id
    , customer_names
    , customer_genders
    , customer_emails
    , normalized_phone
    , customer_address
    , region
FROM customers
WHERE customer_emails IS NOT NULL
AND region IS NOT NULL
