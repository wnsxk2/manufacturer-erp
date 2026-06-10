-- 외래키 제약 일괄 정의 (fk_t_employee_* 외 9개)
-- 선행: ddl/01_create_table.sql, ddl/02_primary_key.sql

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
