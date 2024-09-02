WITH products AS (
    SELECT 
        CAST(product_id AS INT64) as product_id
        , category as product_category
        , names as product_names
        , descriptions as product_descriptions
    FROM {{ source('dreamshop_raw', 'products') }}
)
SELECT
    product_id
    , product_category
    , product_names
    , product_descriptions
FROM products
