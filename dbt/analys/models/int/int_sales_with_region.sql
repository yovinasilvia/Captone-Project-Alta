WITH sales_agg AS (
    SELECT
        s.sale_id,
        s.product_id,
        s.sale_dates,
        SUM(s.sale_qty) AS total_sales,
        ROUND(AVG(SUM(s.sale_qty)) OVER (PARTITION BY s.product_id ORDER BY s.sale_dates), 1) AS avg_sales_per_period,
        ROUND(
            (SUM(s.sale_qty) - LAG(SUM(s.sale_qty)) OVER (PARTITION BY s.product_id ORDER BY s.sale_dates)) / 
            LAG(SUM(s.sale_qty)) OVER (PARTITION BY s.product_id ORDER BY s.sale_dates), 
            1
        ) AS sales_growth
    FROM
        {{ ref('stg_sales') }} s
    GROUP BY
        s.sale_id, s.product_id, s.sale_dates
)
SELECT
    s.product_id
    , p.product_names         -- Adjusted to match correct column name from products table
    , p.product_category      -- Product category correctly referenced from products table
    , s.sale_dates            -- Sale dates from aggregated sales data
    , s.total_sales
    , s.avg_sales_per_period
    , s.sales_growth
    , c.region                 -- Region correctly referenced from customers table if applicable
FROM sales_agg s
LEFT JOIN {{ ref('stg_products') }} p ON s.product_id = p.product_id
LEFT JOIN {{ ref('stg_customers') }} c ON s.sale_id = c.sale_id  -- Ensure correct join column


-- This table will aggregate sales data by product and date, including sales metrics needed for further analysis.