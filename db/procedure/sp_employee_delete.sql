-- 사원 삭제 (soft delete: is_active = false)                                                                                                 
-- 선행: 없음                                                                                                                                 
                                                                                                                                                
CREATE OR REPLACE PROCEDURE sp_employee_delete(                                                                                               
    p_id BIGINT                                                                                                                               
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  DECLARE                                                                                                                                       
      v_is_active BOOLEAN;                                                                                                                      
  BEGIN                                                                                                                                         
      -- 필수값 검증                                                                                                                         
      IF p_id IS NULL THEN                                                                                                                      
          RAISE EXCEPTION '사원 ID는 필수입니다.';                                                                                              
      END IF;                                                                                                                                   
                                                                                                                                                
      -- 사원 존재 및 재직 여부 확인                                                                                                         
      SELECT is_active                                                                                                                          
        INTO v_is_active                                                                                                                        
        FROM t_employee                                                                                                                         
       WHERE id = p_id                                                                                                                          
         FOR UPDATE;                                                                                                                            
                                                                                                                                                
      IF v_is_active IS NULL THEN                                                                                                               
          RAISE EXCEPTION '존재하지 않는 사원입니다. employee_id: %', p_id;                                                                     
      END IF;                                                                                                                                   
                                                                                                                                                
      IF NOT v_is_active THEN                                                                                                                   
          RAISE EXCEPTION '이미 퇴사 처리된 사원입니다. employee_id: %', p_id;                                                                  
      END IF;                                                                                                                                   
                                                                                                                                                
      -- is_active 변경을 통한 퇴사 처리                                                                           
      UPDATE t_employee                                                                                                                         
         SET is_active        = FALSE                                                                                                           
           , resignation_date = NOW()                                                                                                                                                                                                                     
           , updated_at       = NOW()                                                                                                           
       WHERE id = p_id;                                                                                                                         
  END;                                                                                                                                          
  $$;  
