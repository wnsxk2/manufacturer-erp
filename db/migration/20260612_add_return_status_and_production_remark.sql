-- 반품 상태 및 생산 비고 컬럼을 추가한다.
-- 선행: db/ddl/01_create_table.sql

ALTER TABLE t_product_return
ADD COLUMN IF NOT EXISTS return_status VARCHAR(20) NOT NULL DEFAULT 'REQUESTED';

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'ck_t_product_return_return_status'
    ) THEN
        ALTER TABLE t_product_return
        ADD CONSTRAINT ck_t_product_return_return_status
        CHECK (return_status IN ('REQUESTED', 'COMPLETED'));
    END IF;
END $$;

COMMENT ON COLUMN t_product_return.return_status IS '반품 상태';

ALTER TABLE t_production
ADD COLUMN IF NOT EXISTS remark TEXT NULL;

COMMENT ON COLUMN t_production.remark IS '비고';
