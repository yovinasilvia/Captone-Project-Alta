WITH sales AS (
    SELECT 
        CAST(sale_id AS INT64) as sale_id
        , CAST(product_id AS INT64) as product_id
        , CAST(names AS STRING) as product_names
        , SAFE_CAST(NULLIF(dates, '') AS DATE) as sale_dates
        , CAST(quantity AS INT64) as sale_qty
        , CAST(prices AS NUMERIC) as sale_prices
        , sale_amount as total_sales
    FROM {{ source('dreamshop_raw', 'sales') }}
)
SELECT
    sale_id
    , product_id
    , product_names
    , sale_dates
    , sale_qty
    , sale_prices
    , total_sales
FROM sales
WHERE sale_dates IS NOT NULL
  AND total_sales > 0
  AND sale_qty > 0
