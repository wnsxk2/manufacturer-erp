-- Drop
DROP TABLE IF EXISTS t_product_return CASCADE;
DROP TABLE IF EXISTS t_product_order CASCADE;
DROP TABLE IF EXISTS t_inventory CASCADE;
DROP TABLE IF EXISTS t_production CASCADE;
DROP TABLE IF EXISTS t_employee CASCADE;
DROP TABLE IF EXISTS t_customer CASCADE;
DROP TABLE IF EXISTS t_product CASCADE;

DROP TABLE IF EXISTS cd_return_reason CASCADE;
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
    , order_status VARCHAR(20) NOT NULL DEFAULT 'ORDERED'
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

-- Primary Key
ALTER TABLE cd_department
ADD CONSTRAINT pk_cd_department
PRIMARY KEY (id);

ALTER TABLE cd_employee_rank
ADD CONSTRAINT pk_cd_employee_rank
PRIMARY KEY (id);

ALTER TABLE cd_return_reason
ADD CONSTRAINT pk_cd_return_reason
PRIMARY KEY (id);

ALTER TABLE t_product
ADD CONSTRAINT pk_t_product
PRIMARY KEY (id);

ALTER TABLE t_customer
ADD CONSTRAINT pk_t_customer
PRIMARY KEY (id);

ALTER TABLE t_employee
ADD CONSTRAINT pk_t_employee
PRIMARY KEY (id);

ALTER TABLE t_production
ADD CONSTRAINT pk_t_production
PRIMARY KEY (id);

ALTER TABLE t_inventory
ADD CONSTRAINT pk_t_inventory
PRIMARY KEY (id);

ALTER TABLE t_product_order
ADD CONSTRAINT pk_t_product_order
PRIMARY KEY (id);

ALTER TABLE t_product_return
ADD CONSTRAINT pk_t_product_return
PRIMARY KEY (id);

-- Foreign Key
ALTER TABLE t_employee
ADD CONSTRAINT fk_t_employee_department_id
FOREIGN KEY (department_id)
REFERENCES cd_department (id);

ALTER TABLE t_employee
ADD CONSTRAINT fk_t_employee_employee_rank_id
FOREIGN KEY (employee_rank_id)
REFERENCES cd_employee_rank (id);

ALTER TABLE t_production
ADD CONSTRAINT fk_t_production_employee_id
FOREIGN KEY (employee_id)
REFERENCES t_employee (id);

ALTER TABLE t_production
ADD CONSTRAINT fk_t_production_product_id
FOREIGN KEY (product_id)
REFERENCES t_product (id);

ALTER TABLE t_inventory
ADD CONSTRAINT fk_t_inventory_product_id
FOREIGN KEY (product_id)
REFERENCES t_product (id);

ALTER TABLE t_product_order
ADD CONSTRAINT fk_t_product_order_customer_id
FOREIGN KEY (customer_id)
REFERENCES t_customer (id);

ALTER TABLE t_product_order
ADD CONSTRAINT fk_t_product_order_product_id
FOREIGN KEY (product_id)
REFERENCES t_product (id);

ALTER TABLE t_product_return
ADD CONSTRAINT fk_t_product_return_product_order_id
FOREIGN KEY (product_order_id)
REFERENCES t_product_order (id);

ALTER TABLE t_product_return
ADD CONSTRAINT fk_t_product_return_return_reason_id
FOREIGN KEY (return_reason_id)
REFERENCES cd_return_reason (id);

-- Index
CREATE UNIQUE INDEX uk_cd_department_name
ON cd_department (name);

CREATE UNIQUE INDEX uk_cd_employee_rank_name
ON cd_employee_rank (name);

CREATE UNIQUE INDEX uk_cd_return_reason_reason
ON cd_return_reason (reason);

CREATE INDEX ix_t_employee_department_id
ON t_employee (department_id);

CREATE INDEX ix_t_employee_employee_rank_id
ON t_employee (employee_rank_id);

CREATE INDEX ix_t_production_employee_id
ON t_production (employee_id);

CREATE INDEX ix_t_production_product_id
ON t_production (product_id);

CREATE UNIQUE INDEX uk_t_inventory_product_id
ON t_inventory (product_id);

CREATE INDEX ix_t_product_order_customer_id
ON t_product_order (customer_id);

CREATE INDEX ix_t_product_order_product_id
ON t_product_order (product_id);

CREATE INDEX ix_t_product_return_product_order_id
ON t_product_return (product_order_id);

CREATE INDEX ix_t_product_return_return_reason_id
ON t_product_return (return_reason_id);

-- Comment
COMMENT ON TABLE cd_department IS '부서 코드 테이블';
COMMENT ON COLUMN cd_department.id IS '부서 ID';
COMMENT ON COLUMN cd_department.name IS '부서명';
COMMENT ON COLUMN cd_department.created_at IS '생성일시';
COMMENT ON COLUMN cd_department.updated_at IS '수정일시';

COMMENT ON TABLE cd_employee_rank IS '직급 코드 테이블';
COMMENT ON COLUMN cd_employee_rank.id IS '직급 ID';
COMMENT ON COLUMN cd_employee_rank.name IS '직급명';
COMMENT ON COLUMN cd_employee_rank.created_at IS '생성일시';
COMMENT ON COLUMN cd_employee_rank.updated_at IS '수정일시';

COMMENT ON TABLE cd_return_reason IS '반품 사유 코드 테이블';
COMMENT ON COLUMN cd_return_reason.id IS '반품 사유 ID';
COMMENT ON COLUMN cd_return_reason.reason IS '반품 사유';
COMMENT ON COLUMN cd_return_reason.created_at IS '생성일시';
COMMENT ON COLUMN cd_return_reason.updated_at IS '수정일시';

COMMENT ON TABLE t_product IS '제품 테이블';
COMMENT ON COLUMN t_product.id IS '제품 ID';
COMMENT ON COLUMN t_product.name IS '제품명';
COMMENT ON COLUMN t_product.price IS '제품 단가';
COMMENT ON COLUMN t_product.is_active IS '사용 여부';
COMMENT ON COLUMN t_product.created_at IS '생성일시';
COMMENT ON COLUMN t_product.updated_at IS '수정일시';

COMMENT ON TABLE t_customer IS '고객 테이블';
COMMENT ON COLUMN t_customer.id IS '고객 ID';
COMMENT ON COLUMN t_customer.name IS '고객명';
COMMENT ON COLUMN t_customer.address IS '고객 주소';
COMMENT ON COLUMN t_customer.contract_date IS '계약일시';
COMMENT ON COLUMN t_customer.is_active IS '사용 여부';
COMMENT ON COLUMN t_customer.created_at IS '생성일시';
COMMENT ON COLUMN t_customer.updated_at IS '수정일시';

COMMENT ON TABLE t_employee IS '사원 테이블';
COMMENT ON COLUMN t_employee.id IS '사원 ID';
COMMENT ON COLUMN t_employee.department_id IS '부서 ID';
COMMENT ON COLUMN t_employee.employee_rank_id IS '직급 ID';
COMMENT ON COLUMN t_employee.name IS '사원명';
COMMENT ON COLUMN t_employee.rrn IS '주민등록번호';
COMMENT ON COLUMN t_employee.address IS '주소';
COMMENT ON COLUMN t_employee.start_date IS '입사일시';
COMMENT ON COLUMN t_employee.resignation_date IS '퇴사일시';
COMMENT ON COLUMN t_employee.is_active IS '재직 여부';
COMMENT ON COLUMN t_employee.created_at IS '생성일시';
COMMENT ON COLUMN t_employee.updated_at IS '수정일시';

COMMENT ON TABLE t_production IS '생산 이력 테이블';
COMMENT ON COLUMN t_production.id IS '생산 ID';
COMMENT ON COLUMN t_production.employee_id IS '사원 ID';
COMMENT ON COLUMN t_production.product_id IS '제품 ID';
COMMENT ON COLUMN t_production.quantity IS '생산 수량';
COMMENT ON COLUMN t_production.produced_at IS '생산일시';
COMMENT ON COLUMN t_production.created_at IS '생성일시';
COMMENT ON COLUMN t_production.updated_at IS '수정일시';

COMMENT ON TABLE t_inventory IS '재고 테이블';
COMMENT ON COLUMN t_inventory.id IS '재고 ID';
COMMENT ON COLUMN t_inventory.product_id IS '제품 ID';
COMMENT ON COLUMN t_inventory.stock_quantity IS '현재 재고 수량';
COMMENT ON COLUMN t_inventory.created_at IS '생성일시';
COMMENT ON COLUMN t_inventory.updated_at IS '수정일시';

COMMENT ON TABLE t_product_order IS '주문 테이블';
COMMENT ON COLUMN t_product_order.id IS '주문 ID';
COMMENT ON COLUMN t_product_order.customer_id IS '고객 ID';
COMMENT ON COLUMN t_product_order.product_id IS '제품 ID';
COMMENT ON COLUMN t_product_order.quantity IS '주문 수량';
COMMENT ON COLUMN t_product_order.order_status IS '주문 상태';
COMMENT ON COLUMN t_product_order.ordered_at IS '주문일시';
COMMENT ON COLUMN t_product_order.created_at IS '생성일시';
COMMENT ON COLUMN t_product_order.updated_at IS '수정일시';

COMMENT ON TABLE t_product_return IS '반품 테이블';
COMMENT ON COLUMN t_product_return.id IS '반품 ID';
COMMENT ON COLUMN t_product_return.product_order_id IS '주문 ID';
COMMENT ON COLUMN t_product_return.return_reason_id IS '반품 사유 ID';
COMMENT ON COLUMN t_product_return.quantity IS '반품 수량';
COMMENT ON COLUMN t_product_return.returned_at IS '반품일시';
COMMENT ON COLUMN t_product_return.created_at IS '생성일시';
COMMENT ON COLUMN t_product_return.updated_at IS '수정일시';
