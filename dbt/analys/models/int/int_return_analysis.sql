SELECT
    r.product_id
    , COUNT(r.return_id) AS total_returns
    , (COUNT(r.return_id) / NULLIF(SUM(s.sale_qty), 0)) * 100 AS return_rate
FROM
    {{ ref('stg_returns') }} r
LEFT JOIN {{ ref('stg_sales') }} s ON r.product_id = s.product_id
GROUP BY r.product_id


-- This table will calculate return rates based on sales and return data.