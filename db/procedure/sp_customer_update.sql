-- 고객 정보 수정 
-- 선행: 없음
CREATE OR REPLACE PROCEDURE sp_customer_update(
    p_id            BIGINT
    , p_name          VARCHAR(50)
    , p_address       VARCHAR(100)
    , p_contract_date TIMESTAMPTZ
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_is_active BOOLEAN;
BEGIN
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        RAISE EXCEPTION '고객명은 필수입니다.';
    END IF;

    IF p_address IS NULL OR TRIM(p_address) = '' THEN
        RAISE EXCEPTION '고객 주소는 필수입니다.';
    END IF;

    IF p_contract_date IS NULL THEN
        RAISE EXCEPTION '계약일시는 필수입니다.';
    END IF;

    SELECT is_active
      INTO v_is_active
      FROM t_customer
     WHERE id = p_id
       FOR UPDATE;

    IF v_is_active IS NULL THEN
        RAISE EXCEPTION '존재하지 않는 고객입니다. customer_id: %', p_id;
    END IF;

    IF NOT v_is_active THEN
        RAISE EXCEPTION '비활성 고객은 수정할 수 없습니다. customer_id: %', p_id;
    END IF;

    UPDATE t_customer
       SET name          = TRIM(p_name)
         , address       = TRIM(p_address)
         , contract_date = p_contract_date
         , updated_at    = NOW()
     WHERE id = p_id;
END;
$$;
