WITH sentiment_analysis AS (
    SELECT
         cr.product_id 
         , cr.product_reviews
        -- Sentiment classification logic with case-insensitive matching
        , CASE 
            WHEN LOWER(product_reviews) LIKE '%impressed%' 
              OR LOWER(product_reviews) LIKE '%great%' 
              OR LOWER(product_reviews) LIKE '%responsive%' 
              OR LOWER(product_reviews) LIKE '%satisfied%' 
            THEN 'Positive'
            WHEN LOWER(product_reviews) LIKE '%defective%' 
              OR LOWER(product_reviews) LIKE '%not as described%' 
              OR LOWER(product_reviews) LIKE '%damaged%' 
            THEN 'Negative'
            ELSE 'Neutral'
        END AS sentiment
        , cr.product_ratings
        , p.product_category  -- Include product category
    FROM
        {{ ref('stg_customer_reviews') }} cr
    LEFT JOIN {{ ref('stg_products') }} p ON cr.product_id = p.product_id
)
SELECT
    product_id
    , product_category  -- Include product category
    , ROUND(AVG(product_ratings), 1) AS avg_rating
    , COUNT(product_reviews) AS combined_reviews
    , sentiment
FROM sentiment_analysis
GROUP BY product_id, product_category, sentiment


-- This table will analyze customer reviews to determine sentiment categories, average ratings, and count of reviews.