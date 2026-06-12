-- 제조사 ERP MVP용 샘플 데이터 (PostgreSQL)
-- 실행 전제: ddl.sql 실행 직후 (모든 테이블 비어 있는 상태)
-- 작성 기준일: 2026-05-28

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


-- ============================================================
-- 2) 마스터 테이블
-- ============================================================

-- 2-1) 제품 (id 1~18 순서 확정)
-- 가구 7종 (id 1~7), 조명 4종 (id 8~11), 수납 7종 (id 12~18)
-- is_active=FALSE: id 16(행거 H2), id 17(옷장 C1) → 단종 제품
INSERT INTO t_product (name, price, is_active) VALUES
('책상 A1',      180000, TRUE)   --  1
, ('책상 B2',      240000, TRUE)   --  2
, ('의자 S1',       89000, TRUE)   --  3
, ('의자 S2',      120000, TRUE)   --  4
, ('의자 P3',      155000, TRUE)   --  5
, ('책장 W1',      135000, TRUE)   --  6
, ('책장 W2',      210000, TRUE)   --  7
, ('LED 스탠드 L1', 45000, TRUE)   --  8
, ('LED 스탠드 L2', 68000, TRUE)   --  9
, ('펜던트 P1',     72000, TRUE)   -- 10
, ('펜던트 P2',    115000, TRUE)   -- 11
, ('서랍장 D1',    165000, TRUE)   -- 12
, ('서랍장 D2',    230000, TRUE)   -- 13
, ('수납함 K1',     38000, TRUE)   -- 14
, ('수납함 K2',     55000, TRUE)   -- 15
, ('행거 H1',       48000, TRUE)   -- 16
, ('행거 H2',       79000, FALSE)  -- 17 단종
, ('옷장 C1',      480000, FALSE); -- 18 단종

-- 2-2) 고객 (id 1~25 순서 확정)
-- contract_date: 모두 2025-02-28 이하 (주문일 2025-03-01 이상과 충돌 방지)
-- is_active=FALSE: id 8, 15, 22
INSERT INTO t_customer (name, address, contract_date, is_active) VALUES
('한성상사',           '서울시 강남구 테헤란로 100',         '2025-01-05 09:00:00+09', TRUE)   --  1
, ('대원유통',           '경기도 성남시 분당구 판교로 50',      '2025-01-08 10:00:00+09', TRUE)   --  2
, ('미래인테리어',        '서울시 마포구 홍익로 30',            '2025-01-10 09:30:00+09', TRUE)   --  3
, ('(주)신성퍼니처',     '인천시 남동구 논현로 200',            '2025-01-12 11:00:00+09', TRUE)   --  4
, ('한국홈데코',         '경기도 수원시 영통구 광교로 15',      '2025-01-15 09:00:00+09', TRUE)   --  5
, ('부산상사',           '부산시 해운대구 센텀로 80',           '2025-01-17 10:30:00+09', TRUE)   --  6
, ('대구유통',           '대구시 수성구 달구벌대로 500',        '2025-01-20 09:00:00+09', TRUE)   --  7
, ('광주인테리어',        '광주시 서구 상무대로 111',           '2025-01-22 11:00:00+09', FALSE)  --  8 비활성
, ('(주)대전퍼니처',    '대전시 유성구 대학로 99',             '2025-01-24 10:00:00+09', TRUE)   --  9
, ('성동홈데코',         '서울시 성동구 왕십리로 50',           '2025-01-26 09:30:00+09', TRUE)   -- 10
, ('경기상사',           '경기도 안양시 동안구 평촌대로 200',   '2025-01-28 10:00:00+09', TRUE)   -- 11
, ('인천유통',           '인천시 연수구 송도과학로 32',         '2025-01-30 09:00:00+09', TRUE)   -- 12
, ('남양주인테리어',      '경기도 남양주시 다산중앙로 100',     '2025-02-01 11:00:00+09', TRUE)   -- 13
, ('(주)고양퍼니처',    '경기도 고양시 일산동구 중앙로 1300',  '2025-02-03 10:30:00+09', TRUE)   -- 14
, ('시흥홈데코',         '경기도 시흥시 마유로 420',            '2025-02-05 09:00:00+09', FALSE)  -- 15 비활성
, ('강남상사',           '서울시 강남구 선릉로 428',            '2025-02-07 10:00:00+09', TRUE)   -- 16
, ('울산유통',           '울산시 남구 삼산로 100',              '2025-02-08 09:30:00+09', TRUE)   -- 17
, ('창원인테리어',        '경남 창원시 의창구 창원대로 18',     '2025-02-10 11:00:00+09', TRUE)   -- 18
, ('(주)천안퍼니처',    '충남 천안시 서북구 성환읍 성환로 50', '2025-02-12 10:00:00+09', TRUE)   -- 19
, ('청주홈데코',         '충북 청주시 흥덕구 직지대로 300',     '2025-02-14 09:00:00+09', TRUE)   -- 20
, ('전주상사',           '전북 전주시 완산구 전주천동로 60',    '2025-02-17 10:30:00+09', TRUE)   -- 21
, ('제주유통',           '제주시 연동 신대로 20',               '2025-02-19 09:00:00+09', FALSE)  -- 22 비활성
, ('춘천인테리어',        '강원도 춘천시 중앙로 55',            '2025-02-21 11:00:00+09', TRUE)   -- 23
, ('(주)원주퍼니처',    '강원도 원주시 서원대로 100',          '2025-02-24 10:00:00+09', TRUE)   -- 24
, ('포항홈데코',         '경북 포항시 남구 중흥로 200',         '2025-02-28 09:00:00+09', TRUE);  -- 25

-- 2-3) 사원 (id 1~35 순서 확정)
-- id  1~12: DEP02(생산부)/DEP04(품질관리부), start_date ≤ 2025-01-31 (생산 풀)
-- id 13~35: 나머지 부서
-- 퇴직자: id 30, 31, 32, 33 (resignation_date IS NOT NULL, is_active=FALSE)
INSERT INTO t_employee (department_id, employee_rank_id, name, rrn, address, start_date, resignation_date, is_active) VALUES
-- 생산 풀 (id 1~12)
('DEP02', 'RNK02', '김민준', '880315-1234561', '서울시 노원구 공릉로 100',        '2022-03-02 09:00:00+09', NULL, TRUE)  --  1
, ('DEP02', 'RNK03', '이서연', '901122-2345672', '경기도 구리시 아차산로 50',        '2021-01-04 09:00:00+09', NULL, TRUE)  --  2
, ('DEP02', 'RNK01', '박도윤', '970801-1456783', '서울시 중랑구 망우로 30',          '2024-07-01 09:00:00+09', NULL, TRUE)  --  3
, ('DEP02', 'RNK04', '최수아', '850620-2567894', '경기도 남양주시 오남읍 팔현리 1', '2018-02-01 09:00:00+09', NULL, TRUE)  --  4
, ('DEP02', 'RNK02', '정하준', '930411-1678905', '서울시 도봉구 시루봉로 10',        '2023-04-03 09:00:00+09', NULL, TRUE)  --  5
, ('DEP02', 'RNK03', '강지우', '910703-2789016', '경기도 의정부시 평화로 50',        '2020-08-03 09:00:00+09', NULL, TRUE)  --  6
, ('DEP04', 'RNK02', '윤예준', '940215-1890127', '서울시 강북구 도봉로 200',         '2022-11-01 09:00:00+09', NULL, TRUE)  --  7
, ('DEP04', 'RNK03', '임소윤', '890504-2901238', '경기도 하남시 미사강변대로 10',    '2021-05-04 09:00:00+09', NULL, TRUE)  --  8
, ('DEP02', 'RNK01', '오시우', '990120-1012349', '서울시 은평구 통일로 500',         '2025-01-06 09:00:00+09', NULL, TRUE)  --  9
, ('DEP04', 'RNK04', '한채원', '870930-2123450', '경기도 고양시 덕양구 행주로 30',   '2019-03-04 09:00:00+09', NULL, TRUE)  -- 10
, ('DEP02', 'RNK01', '신준서', '001010-3234561', '서울시 서대문구 연희로 50',        '2025-01-13 09:00:00+09', NULL, TRUE)  -- 11
, ('DEP04', 'RNK02', '배수진', '950628-2345672', '경기도 파주시 금촌로 100',         '2023-09-04 09:00:00+09', NULL, TRUE)  -- 12
-- 영업부 (id 13~22)
, ('DEP01', 'RNK03', '류지안', '920814-1456783', '서울시 강남구 역삼로 100',         '2021-02-01 09:00:00+09', NULL, TRUE)  -- 13
, ('DEP01', 'RNK04', '조하린', '880205-2567894', '서울시 서초구 방배로 50',          '2018-07-02 09:00:00+09', NULL, TRUE)  -- 14
, ('DEP01', 'RNK05', '권현우', '800319-1678905', '서울시 송파구 올림픽로 300',       '2015-04-01 09:00:00+09', NULL, TRUE)  -- 15
, ('DEP01', 'RNK01', '문지호', '020225-3789016', '서울시 강동구 천호대로 200',       '2025-03-03 09:00:00+09', NULL, TRUE)  -- 16
, ('DEP01', 'RNK02', '노은서', '960711-2890127', '경기도 성남시 중원구 성남대로 50', '2023-01-02 09:00:00+09', NULL, TRUE)  -- 17
, ('DEP01', 'RNK03', '심태양', '910426-1901238', '서울시 관악구 봉천로 100',         '2020-06-01 09:00:00+09', NULL, TRUE)  -- 18
, ('DEP01', 'RNK01', '황나은', '001130-4012349', '경기도 광명시 오리로 55',          '2025-01-20 09:00:00+09', NULL, TRUE)  -- 19
, ('DEP01', 'RNK02', '구태민', '970822-1123450', '서울시 영등포구 당산로 30',        '2024-02-05 09:00:00+09', NULL, TRUE)  -- 20
, ('DEP01', 'RNK04', '서유리', '860614-2234561', '서울시 동작구 상도로 100',         '2017-09-04 09:00:00+09', NULL, TRUE)  -- 21
, ('DEP01', 'RNK01', '변도현', '011020-3345672', '경기도 용인시 수지구 신수로 200',  '2025-04-07 09:00:00+09', NULL, TRUE)  -- 22
-- 관리부 (id 23~26)
, ('DEP03', 'RNK03', '방성민', '930101-1456783', '서울시 종로구 창경궁로 10',        '2021-10-04 09:00:00+09', NULL, TRUE)  -- 23
, ('DEP03', 'RNK05', '석지현', '820717-2567894', '서울시 중구 퇴계로 200',           '2013-03-04 09:00:00+09', NULL, TRUE)  -- 24
, ('DEP03', 'RNK02', '탁준혁', '950303-1678905', '서울시 용산구 한강대로 300',       '2022-07-04 09:00:00+09', NULL, TRUE)  -- 25
, ('DEP03', 'RNK01', '편수연', '021215-4789016', '경기도 과천시 관문로 47',          '2025-02-03 09:00:00+09', NULL, TRUE)  -- 26
-- 품질관리부 추가 (id 27~29)
, ('DEP04', 'RNK03', '두민재', '920508-1890127', '서울시 성북구 정릉로 50',          '2021-07-05 09:00:00+09', NULL, TRUE)  -- 27
, ('DEP04', 'RNK01', '마예나', '001225-4901238', '경기도 안산시 단원구 원시로 100',  '2025-01-27 09:00:00+09', NULL, TRUE)  -- 28
, ('DEP04', 'RNK04', '어태훈', '840912-1012349', '경기도 시흥시 경제로 100',         '2016-05-02 09:00:00+09', NULL, TRUE)  -- 29
-- 퇴직자 (id 30~33, is_active=FALSE)
, ('DEP02', 'RNK02', '남기현', '880616-1123450', '서울시 광진구 아차산로 300',       '2019-04-01 09:00:00+09', '2024-12-31 18:00:00+09', FALSE) -- 30
, ('DEP01', 'RNK03', '고수빈', '910209-2234561', '서울시 양천구 목동로 100',         '2020-08-03 09:00:00+09', '2025-06-30 18:00:00+09', FALSE) -- 31
, ('DEP05', 'RNK02', '도재원', '930724-1345672', '경기도 부천시 부흥로 100',         '2022-01-03 09:00:00+09', '2025-09-30 18:00:00+09', FALSE) -- 32
, ('DEP03', 'RNK01', '라하영', '991001-2456783', '경기도 김포시 사우로 30',          '2024-03-04 09:00:00+09', '2025-03-31 18:00:00+09', FALSE) -- 33
-- 물류부 (id 34~35)
, ('DEP05', 'RNK03', '지성호', '900318-1567894', '인천시 서구 청라루미나로 100',     '2021-03-02 09:00:00+09', NULL, TRUE)  -- 34
, (NULL,    'RNK01', '채하은', '030414-4678905', '경기도 화성시 동탄면 동탄산단 2',  '2026-04-14 09:00:00+09', NULL, TRUE); -- 35 부서 미배정 신규


-- ============================================================
-- 3) 트랜잭션 테이블
-- ============================================================

-- 3-1) 생산 이력 (100행)
-- employee_id: 1~12 (생산 풀), 7과 12는 coprime → 전 제품 커버
-- quantity: 40~119 (생산 풀이 충분히 주문보다 크도록 floor 40)
-- produced_at: 2025-02-01 ~ 2026-05-26 분산
INSERT INTO t_production (employee_id, product_id, quantity, produced_at)
SELECT
    ((gs - 1) % 12) + 1                                                         AS employee_id
    , ((gs * 7 - 1) % 18) + 1                                                   AS product_id
    , 40 + ((gs * 13) % 80)                                                      AS quantity
    , TIMESTAMPTZ '2025-02-01 09:00:00+09'
    + ((gs * 37) % 450) * INTERVAL '1 day'
    + ((gs * 11) % 8)   * INTERVAL '1 hour'                                     AS produced_at
FROM generate_series(1, 100) AS gs;

-- 3-2) 주문 (127행 generate_series + 데모 3행 = 130행)
-- customer_id: 1~25 (5와 25 coprime), product_id: 1~18 (5와 18 coprime)
-- quantity: 1~30
-- order_status: gs % 100 기준 25/25/40/10 분포
-- ordered_at: 2025-03-01 ~ 2026-05-20 분산
INSERT INTO t_product_order (customer_id, product_id, quantity, order_status, ordered_at)
SELECT
    ((gs * 5 - 1) % 25) + 1                                                     AS customer_id
    , ((gs * 5 - 1) % 18) + 1                                                   AS product_id
    , 1 + ((gs * 17) % 30)                                                       AS quantity
    , CASE
        WHEN (gs % 100) < 25 THEN 'ORDERED'
        WHEN (gs % 100) < 50 THEN 'SHIPPED'
        WHEN (gs % 100) < 90 THEN 'DELIVERED'
        ELSE 'CANCELLED'
    END                                                                          AS order_status
    , TIMESTAMPTZ '2025-03-01 10:00:00+09'
    + ((gs * 23) % 440) * INTERVAL '1 day'
    + ((gs *  7) % 12)  * INTERVAL '1 hour'                                     AS ordered_at
FROM generate_series(1, 127) AS gs;

-- 데모 대시보드용 명시 행 (최신 날짜, 시연 시 첫 화면에 보이는 대표 데이터)
INSERT INTO t_product_order (customer_id, product_id, quantity, order_status, ordered_at) VALUES
(1,  1, 50, 'DELIVERED', '2026-05-20 14:30:00+09')
, (2,  3, 12, 'SHIPPED',   '2026-05-25 10:00:00+09')
, (5,  7,  8, 'ORDERED',   '2026-05-27 16:45:00+09');

-- 3-3) 반품 (20행)
-- SHIPPED/DELIVERED 주문만 대상, OFFSET 5로 앞부분 건너뜀
-- return_reason_id: RTN001~RTN006 순환
-- quantity: 주문 수량의 1/3 (반품량 ≤ 주문량 보장)
-- returned_at: 주문일 + 7~21일 (반품일 > 주문일 보장)
INSERT INTO t_product_return (product_order_id, return_reason_id, quantity, returned_at)
SELECT
    o.id                                                                                        AS product_order_id
    , 'RTN00' || (((row_number() OVER (ORDER BY o.id) - 1) % 6) + 1)::TEXT                    AS return_reason_id
    , GREATEST(1, o.quantity / 3)                                                               AS quantity
    , o.ordered_at
    + INTERVAL '7 days'
    + ((o.id * 3) % 15) * INTERVAL '1 day'                                                     AS returned_at
FROM t_product_order o
WHERE o.order_status IN ('SHIPPED', 'DELIVERED')
ORDER BY o.id
OFFSET 5 LIMIT 20;  -- noqa: PRS


-- ============================================================
-- 4) 재고 (생산 - 비취소주문 + 반품으로 정확히 계산)
-- ============================================================
INSERT INTO t_inventory (product_id, stock_quantity)
SELECT
    p.id                                                                         AS product_id
    , COALESCE(prod.qty, 0) - COALESCE(ord.qty, 0) + COALESCE(ret.qty, 0)      AS stock_quantity
FROM t_product p
LEFT JOIN (
    SELECT product_id, SUM(quantity) AS qty
    FROM t_production
    GROUP BY product_id
) prod ON prod.product_id = p.id
LEFT JOIN (
    SELECT product_id, SUM(quantity) AS qty
    FROM t_product_order
    WHERE order_status <> 'CANCELLED'
    GROUP BY product_id
) ord ON ord.product_id = p.id
LEFT JOIN (
    SELECT po.product_id, SUM(pr.quantity) AS qty
    FROM t_product_return pr
    JOIN t_product_order po ON po.id = pr.product_order_id
    GROUP BY po.product_id
) ret ON ret.product_id = p.id
ORDER BY p.id;


-- ============================================================
-- 5) 검증 쿼리 (필요 시 주석 해제하여 실행)
-- ============================================================
/*

-- 5-1) 행 수 확인
SELECT 'cd_department'    AS tbl, COUNT(*) AS cnt FROM cd_department
UNION ALL SELECT 'cd_employee_rank',   COUNT(*) FROM cd_employee_rank
UNION ALL SELECT 'cd_return_reason',   COUNT(*) FROM cd_return_reason
UNION ALL SELECT 't_product',          COUNT(*) FROM t_product
UNION ALL SELECT 't_customer',         COUNT(*) FROM t_customer
UNION ALL SELECT 't_employee',         COUNT(*) FROM t_employee
UNION ALL SELECT 't_production',       COUNT(*) FROM t_production
UNION ALL SELECT 't_product_order',    COUNT(*) FROM t_product_order
UNION ALL SELECT 't_product_return',   COUNT(*) FROM t_product_return
UNION ALL SELECT 't_inventory',        COUNT(*) FROM t_inventory
ORDER BY tbl;

-- 5-2) 주문 상태 분포 (ORDERED 25% / SHIPPED 25% / DELIVERED 40% / CANCELLED 10% 목표)
SELECT
    order_status
  , COUNT(*)                                                   AS cnt
  , ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)        AS pct
FROM t_product_order
GROUP BY order_status
ORDER BY cnt DESC;

-- 5-3) 재고 음수 검사 (반드시 0건이어야 통과)
SELECT i.product_id, p.name, i.stock_quantity
FROM t_inventory i
JOIN t_product p ON p.id = i.product_id
WHERE i.stock_quantity < 0;

-- 5-4) 재고 정합성 재계산 검증 (stored = recomputed 이어야 통과)
SELECT
    p.id
  , p.name
  , i.stock_quantity                                                             AS stored
  , COALESCE(prod.qty, 0) - COALESCE(ord.qty, 0) + COALESCE(ret.qty, 0)        AS recomputed
FROM t_product p
JOIN t_inventory i ON i.product_id = p.id
LEFT JOIN (SELECT product_id, SUM(quantity) qty FROM t_production GROUP BY product_id) prod ON prod.product_id = p.id
LEFT JOIN (SELECT product_id, SUM(quantity) qty FROM t_product_order WHERE order_status <> 'CANCELLED' GROUP BY product_id) ord ON ord.product_id = p.id
LEFT JOIN (SELECT po.product_id, SUM(pr.quantity) qty FROM t_product_return pr JOIN t_product_order po ON po.id = pr.product_order_id GROUP BY po.product_id) ret ON ret.product_id = p.id
ORDER BY p.id;

-- 5-5) FK 고아 검사 (모두 0건이어야 통과)
SELECT 'employee.department_id 고아'  AS check_name, COUNT(*) AS cnt FROM t_employee     WHERE department_id IS NOT NULL AND department_id NOT IN (SELECT id FROM cd_department)
UNION ALL SELECT 'production.employee_id 고아',        COUNT(*) FROM t_production   WHERE employee_id NOT IN (SELECT id FROM t_employee)
UNION ALL SELECT 'product_order.customer_id 고아',     COUNT(*) FROM t_product_order WHERE customer_id NOT IN (SELECT id FROM t_customer)
UNION ALL SELECT 'product_return.order_id 고아',       COUNT(*) FROM t_product_return WHERE product_order_id NOT IN (SELECT id FROM t_product_order);

-- 5-6) 반품이 취소 주문을 참조하지 않는지 (0건이어야 통과)
SELECT COUNT(*) AS cancelled_return_cnt
FROM t_product_return pr
JOIN t_product_order po ON po.id = pr.product_order_id
WHERE po.order_status = 'CANCELLED';

*/
