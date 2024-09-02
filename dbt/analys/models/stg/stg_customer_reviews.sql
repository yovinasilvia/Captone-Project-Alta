WITH reviews AS (
    SELECT 
        CAST(review_id AS INT64) as review_id
        , CAST(product_id AS INT64) as product_id
        , CAST(customer_id AS INT64) as customer_id
        , SAFE_CAST(NULLIF(review_dates, '') AS DATE) as review_dates
        , ratings as product_ratings
        , SAFE_CAST(NULLIF(reviews, '') AS STRING) as product_reviews
    FROM {{ source('dreamshop_raw', 'customer_reviews') }}
)
SELECT
    review_id
    , product_id
    , customer_id
    , review_dates
    , product_ratings
    , product_reviews
FROM reviews
WHERE review_dates IS NOT NULL
    AND product_reviews IS NOT NULL
    AND product_ratings IS NOT NULL
    AND product_ratings BETWEEN 1 AND 5
