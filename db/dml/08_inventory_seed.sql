-- t_inventory 집계 INSERT (생산 − 비취소주문 + 단순변심 완료 반품으로 재고 산출, 18행)
-- 선행: dml/05_production_seed.sql, dml/06_order_seed.sql, dml/07_return_seed.sql

-- ============================================================
-- 4) 재고 (생산 - 비취소주문 + 단순변심 완료 반품으로 정확히 계산)
-- ============================================================
INSERT INTO t_inventory (product_id, stock_quantity)
WITH prod AS (
    SELECT
        product_id
        , SUM(quantity) AS qty
    FROM t_production
    GROUP BY product_id
)

, ord AS (
    SELECT
        product_id
        , SUM(quantity) AS qty
    FROM t_product_order
    WHERE order_status_id <> 4
    GROUP BY product_id
)

, ret AS (
    SELECT
        po.product_id
        , SUM(pr.quantity) AS qty
    FROM t_product_return AS pr
    INNER JOIN t_product_order AS po ON pr.product_order_id = po.id
    WHERE
        po.order_status_id = 6
        AND pr.return_reason_id = 'RTN003'
    GROUP BY po.product_id
)

SELECT
    p.id AS product_id
    , COALESCE(prod.qty, 0)
    - COALESCE(ord.qty, 0)
    + COALESCE(ret.qty, 0) AS stock_quantity
FROM t_product AS p
LEFT JOIN prod ON p.id = prod.product_id
LEFT JOIN ord ON p.id = ord.product_id
LEFT JOIN ret ON p.id = ret.product_id
ORDER BY p.id;
