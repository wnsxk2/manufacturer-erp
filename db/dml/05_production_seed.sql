-- t_production 시드 입력 (generate_series 100행, 생산 풀 사원 id 1~12)
-- 선행: dml/02_product_seed.sql, dml/04_employee_seed.sql

-- ============================================================
-- 3-1) 생산 이력 (100행)
-- employee_id: 1~12 (생산 풀), 7과 12는 coprime → 전 제품 커버
-- quantity: 40~119 (생산 풀이 충분히 주문보다 크도록 floor 40)
-- produced_at: 2025-02-01 ~ 2026-05-26 분산
-- ============================================================
INSERT INTO t_production (employee_id, product_id, quantity, produced_at)
SELECT
    ((gs - 1) % 12) + 1 AS employee_id
    , ((gs * 7 - 1) % 18) + 1 AS product_id
    , 40 + ((gs * 13) % 80) AS quantity
    , TIMESTAMPTZ '2025-02-01 09:00:00+09'
    + ((gs * 37) % 450) * INTERVAL '1 day'
    + ((gs * 11) % 8) * INTERVAL '1 hour' AS produced_at
FROM GENERATE_SERIES(1, 100) AS gs;
