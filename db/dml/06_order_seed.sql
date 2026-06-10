-- t_product_order 시드 입력 (generate_series 127행 + 데모 3행, 총 130행)
-- 선행: dml/02_product_seed.sql, dml/03_customer_seed.sql

-- ============================================================
-- 3-2) 주문 (127행 generate_series + 데모 3행 = 130행)
-- customer_id: 1~25 (5와 25 coprime), product_id: 1~18 (5와 18 coprime)
-- quantity: 1~30
-- order_status: gs % 100 기준 25/25/40/10 분포
-- ordered_at: 2025-03-01 ~ 2026-05-20 분산
-- ============================================================
INSERT INTO t_product_order (
    customer_id, product_id, quantity, order_status, ordered_at
)
SELECT
    ((gs * 5 - 1) % 25) + 1 AS customer_id
    , ((gs * 5 - 1) % 18) + 1 AS product_id
    , 1 + ((gs * 17) % 30) AS quantity
    , CASE
        WHEN (gs % 100) < 25 THEN 'ORDERED'
        WHEN (gs % 100) < 50 THEN 'SHIPPED'
        WHEN (gs % 100) < 90 THEN 'DELIVERED'
        ELSE 'CANCELLED'
    END AS order_status
    , TIMESTAMPTZ '2025-03-01 10:00:00+09'
    + ((gs * 23) % 440) * INTERVAL '1 day'
    + ((gs * 7) % 12) * INTERVAL '1 hour' AS ordered_at
FROM GENERATE_SERIES(1, 127) AS gs;

-- 데모 대시보드용 명시 행 (최신 날짜, 시연 시 첫 화면에 보이는 대표 데이터)
INSERT INTO t_product_order (
    customer_id, product_id, quantity, order_status, ordered_at
) VALUES
(1, 1, 50, 'DELIVERED', '2026-05-20 14:30:00+09')
, (2, 3, 12, 'SHIPPED', '2026-05-25 10:00:00+09')
, (5, 7, 8, 'ORDERED', '2026-05-27 16:45:00+09');
