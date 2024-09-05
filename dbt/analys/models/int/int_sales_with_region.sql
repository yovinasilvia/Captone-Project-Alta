WITH sales_agg AS (
    SELECT
        s.sale_id,
        s.product_id,
        s.sale_dates,
        SUM(s.sale_qty) AS total_sales,
        ROUND(AVG(SUM(s.sale_qty)) OVER (PARTITION BY s.product_id ORDER BY s.sale_dates), 1) AS avg_sales_per_period,
        ROUND(
            COALESCE(
                (SUM(s.sale_qty) - LAG(SUM(s.sale_qty)) OVER (PARTITION BY s.product_id ORDER BY s.sale_dates)) / 
                NULLIF(LAG(SUM(s.sale_qty)) OVER (PARTITION BY s.product_id ORDER BY s.sale_dates), 0), 
                0
            ), 1
        ) AS sales_growth
    FROM
        {{ ref('stg_sales') }} s
    GROUP BY
        s.sale_id, s.product_id, s.sale_dates
)
SELECT
    s.product_id
    , p.product_names
    , p.product_category
    , s.sale_dates
    , s.total_sales
    , s.avg_sales_per_period
    , s.sales_growth
    , c.region
FROM sales_agg s
LEFT JOIN {{ ref('stg_products') }} p ON s.product_id = p.product_id
LEFT JOIN (
    SELECT * FROM {{ ref('stg_customers') }}
    WHERE region IS NOT NULL  -- Ensure NULL regions are excluded here
) c ON s.sale_id = c.sale_id
WHERE c.region IS NOT NULL  -- Optional additional filter


-- This table will aggregate sales data by product and date, including sales metrics needed for further analysis.