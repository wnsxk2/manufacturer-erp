-- 상품 목록 조회 (이름 검색 지원)                                                                                                            
-- 선행: 없음                                                                                                                                 
                                                                                                                                                
CREATE OR REPLACE FUNCTION fn_product_list(                                                                                                   
    p_name VARCHAR(50) DEFAULT NULL                                                                                                           
)                                                                                                                                             
RETURNS TABLE(                                                                                                                                
    id         BIGINT                                                                                                                         
    , name       VARCHAR                                                                                                                        
    , price      INTEGER                                                                                                                        
    , is_active  BOOLEAN                                                                                                                        
    , created_at TIMESTAMPTZ                                                                                                                    
    , updated_at TIMESTAMPTZ                                                                                                                    
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  BEGIN                                                                                                                                         
      RETURN QUERY                                                                                                                              
      SELECT                                                                                                                                    
          p.id                                                                                                                                  
        , p.name                                                                                                                                
        , p.price                                                                                                                               
        , p.is_active                                                                                                                           
        , p.created_at                                                                                                                          
        , p.updated_at                                                                                                                          
      FROM t_product p                                                                                                                          
      WHERE (p_name IS NULL OR p.name ILIKE '%' || p_name || '%')                                                                               
      ORDER BY p.id;                                                                                                                            
  END;                                                                                                                                          
  $$;            
