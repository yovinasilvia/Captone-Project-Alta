SELECT
    s.product_id,
    s.product_names,
    s.product_category,   -- Product category included
    s.sale_dates,         -- Sale dates included for time range
    s.region,
    s.total_sales,
    s.avg_sales_per_period,
    s.sales_growth,
    ra.avg_rating,
    ra.combined_reviews,
    ra.sentiment,
    rr.total_returns,
    rr.return_rate
FROM
    {{ ref('int_sales_with_region') }} s
LEFT JOIN {{ ref('int_customer_review_analysis') }} ra ON s.product_id = ra.product_id
LEFT JOIN {{ ref('int_return_analysis') }} rr ON s.product_id = rr.product_id



-- Fungsi: Menggabungkan semua metrik penting (penjualan, rating, pengembalian) dalam satu tabel untuk analisis kinerja produk.