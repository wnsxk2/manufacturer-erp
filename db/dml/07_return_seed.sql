-- t_product_return 시드 입력 (배송완료 주문 대상 20행)
-- 선행: dml/06_order_seed.sql

-- ============================================================
-- 3-3) 반품 (20행)
-- 배송완료 주문만 대상, OFFSET 5로 앞부분 건너뜀
-- return_reason_id: RTN001~RTN006 순환
-- quantity: 주문 수량의 1/3 (반품량 ≤ 주문량 보장)
-- returned_at: 주문일 + 7~21일 (반품일 > 주문일 보장)
-- ============================================================
INSERT INTO t_product_return (product_order_id, return_reason_id, quantity, returned_at)
SELECT
    o.id                                                                                        AS product_order_id
    , 'RTN00' || (((row_number() OVER (ORDER BY o.id) - 1) % 6) + 1)::TEXT                    AS return_reason_id
    , GREATEST(1, o.quantity / 3)                                                               AS quantity
    , o.ordered_at
    + INTERVAL '7 days'
    + ((o.id * 3) % 15) * INTERVAL '1 day'                                                     AS returned_at
FROM t_product_order o
WHERE o.order_status_id = 3
ORDER BY o.id
OFFSET 5 LIMIT 20;  -- noqa: PRS

UPDATE t_product_order AS po
SET
    order_status_id = CASE
        WHEN po.id % 2 = 0 THEN 6
        ELSE 5
    END
    , updated_at = NOW()
FROM t_product_return AS pr
WHERE pr.product_order_id = po.id;
