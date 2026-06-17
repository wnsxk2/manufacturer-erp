CREATE OR REPLACE PROCEDURE sp_customer_list(
    p_cursor  OUT refcursor        
    , p_name    varchar(50) DEFAULT NULL  
)
LANGUAGE plpgsql
AS $$
BEGIN
    OPEN p_cursor FOR
    SELECT
        c.id
      , c.name
      , c.address
      , c.contract_date
      , c.is_active
      , c.created_at
      , c.updated_at
    FROM t_customer c
    WHERE (p_name IS NULL OR c.name ILIKE '%' || p_name || '%')
    ORDER BY c.id;
END;
$$;
