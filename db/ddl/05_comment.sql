-- 전체 테이블 및 컬럼 한국어 코멘트 일괄 등록
-- 선행: ddl/01_create_table.sql

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
