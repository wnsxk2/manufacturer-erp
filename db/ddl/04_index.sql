-- 인덱스 일괄 생성 (UNIQUE 4개 + 일반 8개, 총 12개)
-- 선행: ddl/01_create_table.sql, ddl/02_primary_key.sql

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
