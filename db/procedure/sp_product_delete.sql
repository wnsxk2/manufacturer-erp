-- 상품 삭제 (soft delete: is_active = false)                                                                                                 
-- 선행: 없음                                                                                                                                 
                                                                                                                                                
CREATE OR REPLACE PROCEDURE sp_product_delete(                                                                                                
    p_id BIGINT                                                                                                                               
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
          RAISE EXCEPTION '이미 삭제된 상품입니다. product_id: %', p_id;                                                                        
      END IF;                                                                                                                                   
                                                                                                                                                
      -- soft delete (is_active = false)                                                                                                     
      UPDATE t_product                                                                                                                          
         SET is_active  = FALSE                                                                                                                 
           , updated_at = NOW()                                                                                                                 
       WHERE id = p_id;                                                                                                                         
  END;                                                                                                                                          
  $$;              
