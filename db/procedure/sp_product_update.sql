-- 상품 정보 수정 (활성 상품만)
-- 선행: 없음

CREATE OR REPLACE PROCEDURE sp_product_update(                                                                                                
    p_id    BIGINT                                                                                                                            
    , p_name  VARCHAR(50)                                                                                                                       
    , p_price INTEGER                                                                                                                           
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  DECLARE                                                                                                                                       
      v_is_active BOOLEAN;                                                                                                                      
  BEGIN                                                                                                                                         
      -- 필수값 검증                                                                                                                         
      IF p_id IS NULL THEN                                                                                                                      
          RAISE EXCEPTION '상품 ID는 필수입니다.';                                                                                              
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_name IS NULL OR TRIM(p_name) = '' THEN                                                                                               
          RAISE EXCEPTION '상품명은 필수입니다.';                                                                                               
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_price IS NULL THEN                                                                                                                   
          RAISE EXCEPTION '가격은 필수입니다.';                                                                                                 
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_price < 100 THEN                                                                                                                     
          RAISE EXCEPTION '가격은 100원 이상이어야 합니다.';                                                                                    
      END IF;                                                                                                                                   
                                                                                                                                                
      -- 상품 존재 및 활성 여부 확인                                                                                                         
      SELECT is_active                                                                                                                          
        INTO v_is_active                                                                                                                        
        FROM t_product                                                                                                                          
       WHERE id = p_id                                                                                                                          
         FOR UPDATE;                                                                                                                            
                                                                                                                                                
      IF v_is_active IS NULL THEN                                                                                                               
          RAISE EXCEPTION '존재하지 않는 상품입니다. product_id: %', p_id;                                                                      
      END IF;                                                                                                                                   
                                                                                                                                                
      IF NOT v_is_active THEN                                                                                                                   
          RAISE EXCEPTION '비활성 상품은 수정할 수 없습니다. product_id: %', p_id;                                                              
      END IF;                                                                                                                                   
                                                                                                                                                
      -- 상품 정보 수정                                                                                                                      
      UPDATE t_product                                                                                                                          
         SET name       = p_name                                                                                                                
           , price      = p_price                                                                                                               
           , updated_at = NOW()                                                                                                                 
       WHERE id = p_id;                                                                                                                         
  END;                                                                                                                                          
  $$;                                          
