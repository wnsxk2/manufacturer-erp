-- 모든 테이블 기본키(PK) 제약 정의 (11개)
-- 선행: ddl/01_create_table.sql

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

ALTER TABLE cd_order_status
ADD CONSTRAINT pk_cd_order_status
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
