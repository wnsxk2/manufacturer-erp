-- 고객 추가
-- 선행: 없음
CREATE OR REPLACE PROCEDURE sp_customer_create(
    p_name          VARCHAR(50)
    , p_address       VARCHAR(100)
    , p_contract_date TIMESTAMPTZ DEFAULT NOW()
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        RAISE EXCEPTION '고객명은 필수입니다.';
    END IF;

    IF p_address IS NULL OR TRIM(p_address) = '' THEN
        RAISE EXCEPTION '고객 주소는 필수입니다.';
    END IF;

    INSERT INTO t_customer (
        name
      , address
      , contract_date
    ) VALUES (
        TRIM(p_name)
      , TRIM(p_address)
      , p_contract_date
    );
END;
$$;
