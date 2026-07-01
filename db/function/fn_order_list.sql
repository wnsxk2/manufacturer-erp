-- 주문 목록 조회 (상품명/고객명 포함, 검색 기능)                                                
-- 선행: 없음                                                                                                                                                                                 
CREATE OR REPLACE FUNCTION fn_order_list(                                                        
    p_id            BIGINT       DEFAULT NULL                                                    
    , p_product_name  VARCHAR(50)  DEFAULT NULL                                                    
    , p_customer_name VARCHAR(50)  DEFAULT NULL                                                    
)                                                                                                
RETURNS TABLE(                                                                                   
    id            BIGINT                                                                         
    , customer_id   BIGINT                                                                         
    , customer_name VARCHAR                                                                        
    , product_id    BIGINT                                                                         
    , product_name  VARCHAR                                                                        
    , quantity      INTEGER                                                                        
    , order_status  VARCHAR                                                                        
    , ordered_at    TIMESTAMPTZ                                                                    
    , created_at    TIMESTAMPTZ                                                                    
    , updated_at    TIMESTAMPTZ                                                                    
)                                                                                                
LANGUAGE plpgsql                                                                                 
AS $$                                                                                            
  DECLARE                                                                                          
      v_product_name_pattern  VARCHAR;                                                             
      v_customer_name_pattern VARCHAR;                                                             
  BEGIN                                                                                            
      v_product_name_pattern  := TRIM(p_product_name) || '%';                                      
      v_customer_name_pattern := TRIM(p_customer_name) || '%';                                     
                                                                                                   
      RETURN QUERY                                                                                 
      SELECT                                                                                       
          o.id                                                                                     
        , o.customer_id                                                                            
        , c.name                                                                                   
        , o.product_id                                                                             
        , p.name                                                                                   
        , o.quantity                                                                               
        , o.order_status                                                                           
        , o.ordered_at                                                                             
        , o.created_at                                                                             
        , o.updated_at                                                                             
      FROM t_product_order o                                                                       
      JOIN t_customer c ON c.id = o.customer_id                                                    
      JOIN t_product p ON p.id = o.product_id                                                      
      WHERE (p_id IS NULL OR o.id = p_id)                                                          
        AND (p_product_name IS NULL OR p.name LIKE v_product_name_pattern)                         
        AND (p_customer_name IS NULL OR c.name LIKE v_customer_name_pattern)                       
      ORDER BY o.id;                                                                               
  END;                                                                                             
  $$;        
