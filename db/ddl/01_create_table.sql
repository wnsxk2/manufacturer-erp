-- 제조사 ERP 전체 테이블 정의 (코드 4종 + 마스터/트랜잭션 7종)
-- 선행: 없음 (DROP CASCADE 포함, 단독 실행 가능)

-- Drop
DROP TABLE IF EXISTS t_product_return CASCADE;
DROP TABLE IF EXISTS t_product_order CASCADE;
DROP TABLE IF EXISTS t_inventory CASCADE;
DROP TABLE IF EXISTS t_production CASCADE;
DROP TABLE IF EXISTS t_employee CASCADE;
DROP TABLE IF EXISTS t_customer CASCADE;
DROP TABLE IF EXISTS t_product CASCADE;

DROP TABLE IF EXISTS cd_return_reason CASCADE;
DROP TABLE IF EXISTS cd_order_status CASCADE;
DROP TABLE IF EXISTS cd_employee_rank CASCADE;
DROP TABLE IF EXISTS cd_department CASCADE;

-- Table
CREATE TABLE cd_department (
    id VARCHAR(5)
    , name VARCHAR(30) NOT NULL
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE cd_employee_rank (
    id VARCHAR(5)
    , name VARCHAR(20) NOT NULL
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE cd_return_reason (
    id VARCHAR(6)
    , reason VARCHAR(30) NOT NULL
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE cd_order_status (
    id BIGINT
    , name VARCHAR(20) NOT NULL
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE t_product (
    id BIGINT GENERATED ALWAYS AS IDENTITY
    , name VARCHAR(50) NOT NULL
    , price INTEGER NOT NULL
    , is_active BOOLEAN NOT NULL DEFAULT TRUE
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE t_customer (
    id BIGINT GENERATED ALWAYS AS IDENTITY
    , name VARCHAR(50) NOT NULL
    , address VARCHAR(100) NOT NULL
    , contract_date TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , is_active BOOLEAN NOT NULL DEFAULT TRUE
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE t_employee (
    id BIGINT GENERATED ALWAYS AS IDENTITY
    , department_id VARCHAR(5) NULL
    , employee_rank_id VARCHAR(5) NOT NULL
    , name VARCHAR(20) NOT NULL
    , rrn VARCHAR(14) NOT NULL
    , address VARCHAR(100) NOT NULL
    , start_date TIMESTAMPTZ NOT NULL
    , resignation_date TIMESTAMPTZ NULL
    , is_active BOOLEAN NOT NULL DEFAULT TRUE
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE t_production (
    id BIGINT GENERATED ALWAYS AS IDENTITY
    , employee_id BIGINT NOT NULL
    , product_id BIGINT NOT NULL
    , quantity INTEGER NOT NULL
    , produced_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , remark TEXT NULL
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE t_inventory (
    id BIGINT GENERATED ALWAYS AS IDENTITY
    , product_id BIGINT NOT NULL
    , stock_quantity INTEGER NOT NULL DEFAULT 0
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE t_product_order (
    id BIGINT GENERATED ALWAYS AS IDENTITY
    , customer_id BIGINT NOT NULL
    , product_id BIGINT NOT NULL
    , quantity INTEGER NOT NULL
    , order_status_id BIGINT NOT NULL DEFAULT 1
    , ordered_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE t_product_return (
    id BIGINT GENERATED ALWAYS AS IDENTITY
    , product_order_id BIGINT NOT NULL
    , return_reason_id VARCHAR(6) NOT NULL
    , quantity INTEGER NOT NULL
    , returned_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    , updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE t_product
ADD CONSTRAINT ck_t_product_price
CHECK (price >= 0);

ALTER TABLE t_production
ADD CONSTRAINT ck_t_production_quantity
CHECK (quantity > 0);

ALTER TABLE t_inventory
ADD CONSTRAINT ck_t_inventory_stock_quantity
CHECK (stock_quantity >= 0);

ALTER TABLE t_product_order
ADD CONSTRAINT ck_t_product_order_quantity
CHECK (quantity > 0);

ALTER TABLE t_product_return
ADD CONSTRAINT ck_t_product_return_quantity
CHECK (quantity > 0);
