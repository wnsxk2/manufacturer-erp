-- 고객 삭제(is_active 수정)
-- 선행: 없음 
CREATE OR REPLACE PROCEDURE sp_customer_delete(
    p_id BIGINT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_is_active BOOLEAN;
BEGIN
    SELECT is_active
      INTO v_is_active
      FROM t_customer
     WHERE id = p_id
       FOR UPDATE;

    IF v_is_active IS NULL THEN
        RAISE EXCEPTION '존재하지 않는 고객입니다. customer_id: %', p_id;
    END IF;

    IF NOT v_is_active THEN
        RAISE EXCEPTION '이미 삭제된 고객입니다. customer_id: %', p_id;
    END IF;

    UPDATE t_customer
       SET is_active  = FALSE
         , updated_at = NOW()
     WHERE id = p_id;
END;
$$;
