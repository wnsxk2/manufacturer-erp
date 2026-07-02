-- 모든 테이블 초기화(TRUNCATE CASCADE) 후 코드 테이블 4종 시드 입력
-- 선행: ddl/ 전체 (테이블/PK/FK/인덱스/코멘트 적용 완료 상태)

-- ============================================================
-- 0) 재실행 안전성 보장 (TRUNCATE + IDENTITY 시퀀스 초기화)
-- ============================================================
TRUNCATE TABLE
t_product_return
, t_product_order
, t_inventory
, t_production
, t_employee
, t_customer
, t_product
, cd_return_reason
, cd_order_status
, cd_employee_rank
, cd_department
RESTART IDENTITY CASCADE;


-- ============================================================
-- 1) 코드 테이블
-- ============================================================

-- 1-1) 부서 코드
INSERT INTO cd_department (id, name) VALUES
('DEP01', '영업부')
, ('DEP02', '생산부')
, ('DEP03', '관리부')
, ('DEP04', '품질관리부')
, ('DEP05', '물류부');

-- 1-2) 직급 코드
INSERT INTO cd_employee_rank (id, name) VALUES
('RNK01', '사원')
, ('RNK02', '주임')
, ('RNK03', '대리')
, ('RNK04', '과장')
, ('RNK05', '부장');

-- 1-3) 반품 사유 코드
INSERT INTO cd_return_reason (id, reason) VALUES
('RTN001', '불량')
, ('RTN002', '오배송')
, ('RTN003', '단순변심')
, ('RTN004', '파손')
, ('RTN005', '주문취소')
, ('RTN006', '사이즈상이');

-- 1-4) 주문 상태 코드
INSERT INTO cd_order_status (id, name) VALUES
(1, '주문완료')
, (2, '배송중')
, (3, '배송완료')
, (4, '주문취소')
, (5, '반품신청')
, (6, '반품완료');
