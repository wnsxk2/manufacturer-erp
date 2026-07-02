-- 생산 비고 컬럼을 추가한다.
-- 선행: db/ddl/01_create_table.sql

ALTER TABLE t_production
ADD COLUMN IF NOT EXISTS remark TEXT NULL;

COMMENT ON COLUMN t_production.remark IS '비고';
