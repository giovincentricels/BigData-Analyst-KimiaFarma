-- Membuat tabel analisa baru
CREATE OR REPLACE TABLE `rakamin-kf-analytics-477004.kimia_farma.tabel_analisa_kf`
AS (
SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    p.price AS actual_price,
    t.discount_percentage,

    -- Persentase_gross_laba
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
        ELSE 0
    END AS persentase_gross_laba,

    -- Harga setelah diskon
    (p.price * (1 - t.discount_percentage)) AS nett_sales,

    -- Laba bersih
    (p.price * (1 - t.discount_percentage)) * (
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        WHEN p.price > 500000 THEN 0.30
        ELSE 0
    END
    ) AS nett_profit,
    
    t.rating AS rating_transaksi

-- Join tabel
FROM
    `rakamin-kf-analytics-477004.kimia_farma.kf_final_transaction` AS t
JOIN
    `rakamin-kf-analytics-477004.kimia_farma.kf_product` AS p
    ON t.product_id = p.product_id
JOIN
    `rakamin-kf-analytics-477004.kimia_farma.kf_kantor_cabang` AS kc
    ON t.branch_id = kc.branch_id
);