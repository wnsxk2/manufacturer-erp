-- 주문 상태값을 한국어 고정값으로 변경하고 반품 상태 컬럼을 제거한다.
-- 선행: db/ddl/01_create_table.sql, db/migration/20260612_add_return_status_and_production_remark.sql

ALTER TABLE t_product_order
DROP CONSTRAINT IF EXISTS fk_t_product_order_order_status;

ALTER TABLE t_product_order
DROP CONSTRAINT IF EXISTS fk_t_product_order_order_status_id;

CREATE TABLE IF NOT EXISTS cd_order_status (
    id BIGINT
    , name VARCHAR(20) NOT NULL
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE cd_order_status
ALTER COLUMN id TYPE BIGINT
USING CASE id::TEXT
    WHEN '주문완료' THEN 1
    WHEN '배송중' THEN 2
    WHEN '배송완료' THEN 3
    WHEN '주문취소' THEN 4
    WHEN '반품신청' THEN 5
    WHEN '반품완료' THEN 6
    ELSE id::TEXT::BIGINT
END;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'pk_cd_order_status'
    ) THEN
        ALTER TABLE cd_order_status
        ADD CONSTRAINT pk_cd_order_status
        PRIMARY KEY (id);
    END IF;
END $$;

INSERT INTO cd_order_status (id, name) VALUES
(1, '주문완료')
, (2, '배송중')
, (3, '배송완료')
, (4, '주문취소')
, (5, '반품신청')
, (6, '반품완료')
ON CONFLICT (id) DO UPDATE
    SET
        name       = excluded.name
        , updated_at = NOW();

CREATE UNIQUE INDEX IF NOT EXISTS uk_cd_order_status_name
ON cd_order_status (name);

COMMENT ON TABLE cd_order_status IS '주문 상태 코드 테이블';
COMMENT ON COLUMN cd_order_status.id IS '주문 상태 ID';
COMMENT ON COLUMN cd_order_status.name IS '주문 상태명';
COMMENT ON COLUMN cd_order_status.created_at IS '생성일시';
COMMENT ON COLUMN cd_order_status.updated_at IS '수정일시';

DO $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 't_product_order'
          AND column_name = 'order_status'
    ) AND NOT EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_name = 't_product_order'
          AND column_name = 'order_status_id'
    ) THEN
        ALTER TABLE t_product_order
        RENAME COLUMN order_status TO order_status_id;
    END IF;
END $$;

ALTER TABLE t_product_order
ALTER COLUMN order_status_id DROP DEFAULT;

ALTER TABLE t_product_order
ALTER COLUMN order_status_id TYPE BIGINT
USING CASE order_status_id::TEXT
    WHEN 'ORDERED' THEN 1
    WHEN '주문완료' THEN 1
    WHEN 'SHIPPED' THEN 2
    WHEN '배송중' THEN 2
    WHEN 'DELIVERED' THEN 3
    WHEN '배송완료' THEN 3
    WHEN 'CANCELLED' THEN 4
    WHEN '주문취소' THEN 4
    WHEN 'RETURN_REQUESTED' THEN 5
    WHEN '반품신청' THEN 5
    WHEN 'RETURN_COMPLETED' THEN 6
    WHEN '반품완료' THEN 6
    ELSE order_status_id::TEXT::BIGINT
END;

ALTER TABLE t_product_order
ALTER COLUMN order_status_id SET DEFAULT 1;

ALTER TABLE t_product_return
DROP CONSTRAINT IF EXISTS ck_t_product_return_return_status;

ALTER TABLE t_product_return
DROP COLUMN IF EXISTS return_status;

ALTER TABLE t_product_order
DROP CONSTRAINT IF EXISTS ck_t_product_order_order_status;

ALTER TABLE t_product_order
DROP CONSTRAINT IF EXISTS ck_t_product_order_order_status_id;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_t_product_price'
    ) THEN
        ALTER TABLE t_product
        ADD CONSTRAINT ck_t_product_price
        CHECK (price >= 0);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_t_production_quantity'
    ) THEN
        ALTER TABLE t_production
        ADD CONSTRAINT ck_t_production_quantity
        CHECK (quantity > 0);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_t_inventory_stock_quantity'
    ) THEN
        ALTER TABLE t_inventory
        ADD CONSTRAINT ck_t_inventory_stock_quantity
        CHECK (stock_quantity >= 0);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_t_product_order_quantity'
    ) THEN
        ALTER TABLE t_product_order
        ADD CONSTRAINT ck_t_product_order_quantity
        CHECK (quantity > 0);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_t_product_return_quantity'
    ) THEN
        ALTER TABLE t_product_return
        ADD CONSTRAINT ck_t_product_return_quantity
        CHECK (quantity > 0);
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'fk_t_product_order_order_status_id'
    ) THEN
        ALTER TABLE t_product_order
        ADD CONSTRAINT fk_t_product_order_order_status_id
        FOREIGN KEY (order_status_id)
        REFERENCES cd_order_status (id);
    END IF;
END $$;

COMMENT ON COLUMN t_product_order.order_status_id IS '주문 상태 ID';
