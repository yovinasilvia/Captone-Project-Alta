WITH returns AS (
    SELECT 
        CAST(return_id AS INT64) as return_id
        , CAST(product_id AS INT64) as product_id
        , CAST(customer_id AS INT64) as customer_id
        , SAFE_CAST(NULLIF(dates, '') AS DATE) as return_dates
        , CAST(quantity AS INT64) as return_qty
        , CAST(reasons AS STRING) as return_reason
    FROM {{ source('dreamshop_raw', 'returns') }}
)
SELECT 
    return_id
    , product_id
    , customer_id
    , return_dates
    , return_qty
    , return_reason
FROM returns
WHERE return_dates IS NOT NULL
