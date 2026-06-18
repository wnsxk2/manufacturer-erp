# 프로시저 SQL 작성 컨벤션

## 1. 객체 타입 선택 기준

**조회·계산은 FUNCTION, 상태 변경·작업은 PROCEDURE로 구현한다.** VIEW·TRIGGER는 사용하지 않는다.

### FUNCTION vs PROCEDURE 핵심 차이

| 구분               | FUNCTION                          | PROCEDURE                                |
| ------------------ | --------------------------------- | ---------------------------------------- |
| **반환값**         | 필수 (`RETURNS TYPE` 또는 `VOID`) | 없음 (`INOUT` 파라미터로 반환 가능)      |
| **트랜잭션 제어**  | 불가 (`COMMIT`/`ROLLBACK` 사용 불가) | 가능 (배치 처리 시 내부 `COMMIT`/`ROLLBACK` 허용) |
| **호출 방식**      | `SELECT fn_...()`                 | `CALL sp_...()`                          |
| **주요 용도**      | 조회, 계산, 단순 값 가공          | 상태 변경(검증+DML), 배치·대용량 분할 처리 |

### 용도별 구현 방식

| 용도                         | 구현 방식                                                  |
| ---------------------------- | ---------------------------------------------------------- |
| 단일 값 조회·계산            | FUNCTION — `RETURNS TYPE`                                  |
| 결과 집합 조회               | FUNCTION — `RETURNS TABLE(...)`                            |
| 상태 변경 (검증 + DML)       | PROCEDURE — IN 파라미터                                    |
| 배치·대용량 분할 처리        | PROCEDURE — 내부 `COMMIT`/`ROLLBACK` 허용                  |
| `updated_at` 갱신            | 각 PROCEDURE의 UPDATE 문에서 `SET updated_at = NOW()` 직접 처리 |

> **원칙 요약.** `SELECT` 안에서 값을 반환해야 한다면 FUNCTION. 작업을 수행하거나 트랜잭션을 직접 제어해야 한다면 PROCEDURE.

---

## 2. 네이밍 규칙

### 2-1. 객체 이름

객체 이름 = 파일명(확장자 제외).

**객체 종류별 접두.**

| 접두  | 객체 종류  | 호출 방식           |
| ----- | ---------- | ------------------- |
| `fn_` | FUNCTION   | `SELECT fn_...()`   |
| `sp_` | PROCEDURE  | `CALL sp_...()`     |

`<동작>` 자리에는 아래 표준 동사만 사용한다. 이름만 보고 어떤 DML이 실행되는지 즉시 파악할 수 있어야 한다.

| DML 분류      | 표준 동사   | 예시                                          |
| ------------- | ----------- | --------------------------------------------- |
| INSERT        | `create`    | `sp_order_create`, `sp_customer_create`       |
| UPDATE        | `update`    | `sp_order_update`, `sp_inventory_update`      |
| DELETE        | `delete`    | `sp_order_delete`, `sp_customer_delete`       |
| SELECT (단일) | `get`       | `fn_order_get`, `fn_customer_get`             |
| SELECT (집합) | `list`      | `fn_order_list`, `fn_inventory_list`          |
| INSERT+UPDATE | 도메인 동사 | `sp_inventory_restock`, `sp_order_ship`       |

> **원칙.** INSERT+UPDATE 복합 프로시저처럼 단일 동사로 표현이 불가능한 경우에만 도메인 동사를 사용한다. 그 외에는 예외 없이 위 표의 표준 동사를 사용한다.

| 종류                   | 패턴                          | 예시                                          |
| ---------------------- | ----------------------------- | --------------------------------------------- |
| INSERT 프로시저        | `sp_<도메인>_create`          | `sp_order_create`, `sp_customer_create`       |
| UPDATE 프로시저        | `sp_<도메인>_update`          | `sp_order_update`, `sp_inventory_update`      |
| DELETE 프로시저        | `sp_<도메인>_delete`          | `sp_order_delete`, `sp_customer_delete`       |
| SELECT 단일 함수       | `fn_<도메인>_get`             | `fn_order_get`, `fn_customer_get`             |
| SELECT 집합 함수       | `fn_<도메인>_list`            | `fn_order_list`, `fn_inventory_list`          |
| INSERT+UPDATE 프로시저 | `sp_<도메인>_<도메인 동사>`   | `sp_inventory_restock`, `sp_order_ship`       |

### 2-2. 파라미터 / 변수

| 종류          | 접두 | 예시                                     |
| ------------- | ---- | ---------------------------------------- |
| 입력 파라미터 | `p_` | `p_product_id`, `p_quantity`             |
| 출력 파라미터 | `p_` | `p_stock INOUT INTEGER`                  |
| 지역 변수     | `v_` | `v_current_stock`, `v_order_status`      |

모두 snake_case 소문자. 약어는 사용하지 않는다 (`qty` → `quantity`, `emp` → `employee`).

---

## 3. 파일 구조 / 헤더

### 3-1. 파일 배치

- 객체당 1파일.
- PROCEDURE: `db/procedure/` 하위 **평탄 배치** (하위 디렉토리 없음).
- FUNCTION: `db/function/` 하위 **평탄 배치** (하위 디렉토리 없음).
- 접두(`sp_` / `fn_`)로 정렬 시 자동 그룹핑된다.

### 3-2. 파일 헤더 주석 형식 (DDL 파일과 동일)

```sql
-- <객체 한 줄 한국어 설명>
-- 선행: <의존 파일 목록 또는 없음>
```

- 1행: 객체의 역할을 한국어 한 문장으로.
- 2행: 의존성 없으면 `-- 선행: 없음`.
- 3행부터 본문 시작.

### 3-3. CREATE OR REPLACE

항상 `CREATE OR REPLACE`를 사용한다. 재실행(idempotent)이 보장되어 마이그레이션 스크립트에서 순서만 맞추면 반복 실행할 수 있다.

```sql
CREATE OR REPLACE FUNCTION fn_order_get(...)
...

CREATE OR REPLACE PROCEDURE sp_order_place(...)
...
```

---

## 4. 코드 포맷팅

기존 `db/ddl/`, `db/dml/` 파일의 스타일을 그대로 따른다.

| 규칙      | 내용                                                   |
| --------- | ------------------------------------------------------ |
| 콤마 위치 | **Leading comma** (행 앞)                              |
| 키워드    | 대문자 (`SELECT`, `INSERT`, `RETURNS`, `BEGIN`, `END`) |
| 식별자    | snake_case 소문자                                      |
| 시각 타입 | `TIMESTAMPTZ` (시간대 포함)                            |
| 현재 시각 | `NOW()`                                                |
| 들여쓰기  | 스페이스 4칸                                           |

```sql
-- leading comma 예시
SELECT
    o.id
  , o.quantity
  , p.name AS product_name
FROM t_product_order o
JOIN t_product p ON p.id = o.product_id;
```

---

## 5. 조회 FUNCTION 작성 규칙

### 5-1. 스칼라 반환 — `RETURNS TYPE`

단일 값을 반환할 때는 `RETURNS TYPE` FUNCTION을 사용한다.

```sql
CREATE OR REPLACE FUNCTION fn_<도메인>_<주제>(
    p_param1 TYPE
)
RETURNS TYPE
LANGUAGE plpgsql
AS $$
DECLARE
    v_result TYPE;
BEGIN
    -- 조회 로직
    SELECT col
      INTO v_result
    FROM t_some_table
    WHERE id = p_param1;

    RETURN COALESCE(v_result, 기본값);
END;
$$;
```

호출 방법.

```sql
SELECT fn_<도메인>_<주제>(p_param1 => 값);
```

### 5-2. 결과 집합 반환 — `RETURNS TABLE`

여러 행을 반환할 때는 `RETURNS TABLE(...)` FUNCTION을 사용한다.

```sql
CREATE OR REPLACE FUNCTION fn_<도메인>_<주제>(
    p_filter TEXT DEFAULT NULL
)
RETURNS TABLE(
    col1 TYPE
  , col2 TYPE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.col1
      , t.col2
    FROM t_some_table t
    WHERE (p_filter IS NULL OR t.name ILIKE '%' || p_filter || '%');
END;
$$;
```

호출 방법.

```sql
SELECT * FROM fn_<도메인>_<주제>();

-- 조건 필터 있을 때
SELECT * FROM fn_<도메인>_<주제>(p_filter => '검색어');
```

---

## 6. PROCEDURE 작성 규칙

### 6-1. 기본 구조

```sql
CREATE OR REPLACE PROCEDURE sp_<도메인>_<동작>(
    p_param1 TYPE
  , p_param2 TYPE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_local_var TYPE;
BEGIN
    -- 1. 입력 검증
    -- 2. 데이터 조회 (필요 시 FOR UPDATE)
    -- 3. 비즈니스 검증
    -- 4. DML 실행
END;
$$;
```

### 6-2. 실행 순서 원칙

```
입력 검증 → 행 잠금(FOR UPDATE) → 비즈니스 검증 → INSERT / UPDATE / DELETE
```

검증은 반드시 DML보다 앞에 배치한다. 검증 실패 시 `RAISE EXCEPTION`으로 즉시 중단한다.

### 6-3. 동시성 — 행 잠금

재고 차감·증가처럼 경쟁 조건이 있는 조회는 `SELECT ... FOR UPDATE`로 행을 잠근다.

```sql
SELECT stock_quantity
  INTO v_stock
FROM t_inventory
WHERE product_id = p_product_id
FOR UPDATE;
```

### 6-4. updated_at 갱신

UPDATE 문을 포함하는 PROCEDURE는 반드시 `updated_at = NOW()`를 함께 SET한다. 트리거를 사용하지 않으므로 직접 처리가 필수다.

```sql
UPDATE t_some_table
   SET col          = new_value
     , updated_at   = NOW()
 WHERE id = p_id;
```

### 6-5. 트랜잭션 단위

- 프로시저 1콜 = 논리적 1트랜잭션.
- **상태 변경 PROCEDURE**는 호출자의 트랜잭션을 존중한다. 내부에서 명시적 `COMMIT`/`ROLLBACK`을 사용하지 않는다. 예외를 발생시키면 호출자 트랜잭션이 자동으로 롤백된다.
- **배치·대용량 분할 PROCEDURE**는 처리 단위마다 내부에서 `COMMIT`을 수행할 수 있다 (예: 5만 건 처리 후 `COMMIT`으로 락 부하 절감).
- **FUNCTION**은 트랜잭션 제어가 불가능하다. 함수 내에서 에러가 발생하면 함수를 호출한 쿼리 전체가 롤백된다.

---

## 7. 모범 예시

### 예시 A — SELECT (단일) · `get` 계열 FUNCTION (`fn_inventory_available`)

I-02 기능: 제품 ID → 현재 가용 재고 수량을 반환.

```sql
-- 제품 ID로 현재 가용 재고 수량을 반환하는 함수
-- 선행: ddl/01_create_table.sql

CREATE OR REPLACE FUNCTION fn_inventory_available(
    p_product_id BIGINT
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    SELECT stock_quantity
      INTO v_stock
    FROM t_inventory
    WHERE product_id = p_product_id;

    RETURN COALESCE(v_stock, 0);
END;
$$;
```

호출 방법.

```sql
SELECT fn_inventory_available(p_product_id => 3);
```

---

### 예시 B — SELECT (집합) · `list`/`status` 계열 FUNCTION (`fn_inventory_status`)

I-03 기능: 제품별 현재 재고 + 활성 여부를 반환.

```sql
-- 제품별 현재 재고와 활성 여부를 조회하는 함수
-- 선행: ddl/01_create_table.sql

CREATE OR REPLACE FUNCTION fn_inventory_status()
RETURNS TABLE(
    product_id     BIGINT
  , product_name   VARCHAR
  , is_active      BOOLEAN
  , stock_quantity INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id
      , p.name
      , p.is_active
      , i.stock_quantity
    FROM t_inventory i
    JOIN t_product p ON p.id = i.product_id
    ORDER BY p.id;
END;
$$;
```

호출 방법.

```sql
SELECT * FROM fn_inventory_status();
```

---

### 예시 C — INSERT+UPDATE 복합 · 도메인 동사 계열 PROCEDURE (`sp_order_place`)

O-01 기능: 주문 생성 + 재고 차감 (재고 부족 시 오류, 초기 상태 `ORDERED`).

SPEC 검증 항목.

- 활성 고객(`is_active = TRUE`)만 가능.
- 활성 제품(`is_active = TRUE`)만 가능.
- 주문 수량 ≥ 1.
- 현재 재고 ≥ 주문 수량. 차감 후 음수 불가.

```sql
-- 주문 생성 및 재고 차감 프로시저 (ORDERED 상태로 등록)
-- 선행: ddl/01_create_table.sql

CREATE OR REPLACE PROCEDURE sp_order_place(
    p_customer_id BIGINT
  , p_product_id  BIGINT
  , p_quantity    INTEGER
  , p_ordered_at  TIMESTAMPTZ DEFAULT NOW()
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_is_customer_active BOOLEAN;
    v_is_product_active  BOOLEAN;
    v_stock              INTEGER;
BEGIN
    -- 1. 수량 검증
    IF p_quantity < 1 THEN
        RAISE EXCEPTION '주문 수량은 1 이상이어야 합니다.'
            USING ERRCODE = 'P0001';
    END IF;

    -- 2. 고객 활성 여부 확인
    SELECT is_active
      INTO v_is_customer_active
    FROM t_customer
    WHERE id = p_customer_id;

    IF v_is_customer_active IS NULL THEN
        RAISE EXCEPTION '존재하지 않는 고객입니다. customer_id: %', p_customer_id
            USING ERRCODE = 'P0001';
    END IF;

    IF NOT v_is_customer_active THEN
        RAISE EXCEPTION '비활성 고객은 주문할 수 없습니다. customer_id: %', p_customer_id
            USING ERRCODE = 'P0001';
    END IF;

    -- 3. 제품 활성 여부 확인
    SELECT is_active
      INTO v_is_product_active
    FROM t_product
    WHERE id = p_product_id;

    IF v_is_product_active IS NULL THEN
        RAISE EXCEPTION '존재하지 않는 제품입니다. product_id: %', p_product_id
            USING ERRCODE = 'P0001';
    END IF;

    IF NOT v_is_product_active THEN
        RAISE EXCEPTION '단종된 제품은 주문할 수 없습니다. product_id: %', p_product_id
            USING ERRCODE = 'P0001';
    END IF;

    -- 4. 재고 조회 (행 잠금 — 동시 주문 경쟁 방지)
    SELECT stock_quantity
      INTO v_stock
    FROM t_inventory
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_stock IS NULL THEN
        RAISE EXCEPTION '재고 정보가 없습니다. product_id: %', p_product_id
            USING ERRCODE = 'P0001';
    END IF;

    IF v_stock < p_quantity THEN
        RAISE EXCEPTION '재고가 부족합니다. 현재 재고: %, 요청 수량: %', v_stock, p_quantity
            USING ERRCODE = 'P0001';
    END IF;

    -- 5. 주문 등록
    INSERT INTO t_product_order (
        customer_id
      , product_id
      , quantity
      , order_status
      , ordered_at
    ) VALUES (
        p_customer_id
      , p_product_id
      , p_quantity
      , 'ORDERED'
      , p_ordered_at
    );

    -- 6. 재고 차감
    UPDATE t_inventory
       SET stock_quantity = stock_quantity - p_quantity
         , updated_at     = NOW()
     WHERE product_id = p_product_id;
END;
$$;
```

호출 방법.

```sql
CALL sp_order_place(
    p_customer_id => 1
  , p_product_id  => 3
  , p_quantity    => 10
);
```

---

## 8. 새 파일 작성 체크리스트

새 함수·프로시저를 만들기 전에 아래 항목을 확인한다.

- [ ] 파일 1행: 한국어 역할 주석 작성.
- [ ] 파일 2행: `-- 선행:` 의존성 명시.
- [ ] `CREATE OR REPLACE` 사용 (재실행 가능).
- [ ] 객체 종류 선택: 조회·계산은 FUNCTION(`fn_`), 상태 변경·작업은 PROCEDURE(`sp_`).
- [ ] 객체 이름이 `fn_<도메인>_<동작>` 또는 `sp_<도메인>_<동작>` 패턴을 따름.
- [ ] `<동작>`에 표준 동사 사용 (`create`/`update`/`delete`/`get`/`list`, 복합만 도메인 동사).
- [ ] 파라미터 이름에 `p_` 접두, 지역 변수에 `v_` 접두.
- [ ] 식별자에 약어 사용 안 함 (`qty` → `quantity`).
- [ ] FUNCTION은 `db/function/`, PROCEDURE는 `db/procedure/` 하위에 평탄 배치.
- [ ] Leading comma · 키워드 대문자 · 4칸 들여쓰기 준수.
- [ ] 시각 타입은 `TIMESTAMPTZ`, 현재 시각은 `NOW()` 사용.
- [ ] 조회 단일 값은 `RETURNS TYPE` + `RETURN`, 집합은 `RETURNS TABLE` + `RETURN QUERY` 사용.
- [ ] 상태 변경 PROCEDURE: 검증 로직이 DML 앞에 배치됨.
- [ ] 재고 차감·증가 등 경쟁 조건에 `FOR UPDATE` 적용.
- [ ] 상태 변경 PROCEDURE: 내부 명시적 `COMMIT`/`ROLLBACK` 미사용 (호출자 트랜잭션 존중).
- [ ] `RAISE EXCEPTION` 메시지가 한국어.
- [ ] UPDATE 문에 `updated_at = NOW()` 포함.
