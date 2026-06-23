-- 사원 정보 수정 (재직 중인 사원만)                                                                                                          
-- 선행: 없음                                                                                                 
                                                                                                                                                
CREATE OR REPLACE PROCEDURE sp_employee_update(                                                                                               
    p_id               BIGINT                                                                                                                 
    , p_employee_rank_id VARCHAR(5)                                                                                                             
    , p_name             VARCHAR(20)                                                                                                            
    , p_rrn              VARCHAR(14)                                                                                                            
    , p_address          VARCHAR(100)                                                                                                           
    , p_start_date       TIMESTAMPTZ                                                                                                            
    , p_department_id    VARCHAR(5) DEFAULT NULL                                                                                                
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  DECLARE                                                                                                                                       
      v_is_active BOOLEAN;                                                                                                                      
  BEGIN                                                                                                                                         
      -- 필수값 및 주민번호 포맷 검증                                                                                                                         
      IF p_id IS NULL THEN                                                                                                                      
          RAISE EXCEPTION '사원 ID는 필수입니다.';                                                                                              
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_employee_rank_id IS NULL OR TRIM(p_employee_rank_id) = '' THEN                                                                       
          RAISE EXCEPTION '직급은 필수입니다.';                                                                                                 
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_name IS NULL OR TRIM(p_name) = '' THEN                                                                                               
          RAISE EXCEPTION '사원명은 필수입니다.';                                                                                               
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_rrn IS NULL OR TRIM(p_rrn) = '' THEN                                                                                                 
          RAISE EXCEPTION '주민등록번호는 필수입니다.';                                                                                         
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_rrn !~ '^\d{6}-\d{7}$' THEN                                                                                                          
          RAISE EXCEPTION '주민등록번호 형식이 올바르지 않습니다. (예: 000101-1234567)';                                                        
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_address IS NULL OR TRIM(p_address) = '' THEN                                                                                         
          RAISE EXCEPTION '주소는 필수입니다.';                                                                                                 
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_start_date IS NULL THEN                                                                                                              
          RAISE EXCEPTION '입사일은 필수입니다.';                                                                                               
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
          RAISE EXCEPTION '퇴사한 사원은 수정할 수 없습니다. employee_id: %', p_id;                                                             
      END IF;                                                                                                                                   
                                                                                                                                                
      -- 사원 정보 수정                                                                                                                      
      UPDATE t_employee                                                                                                                         
         SET department_id    = p_department_id                                                                                                 
           , employee_rank_id = p_employee_rank_id                                                                                              
           , name             = p_name                                                                                                          
           , rrn              = p_rrn                                                                                                           
           , address          = p_address                                                                                                       
           , start_date       = p_start_date                                                                                                    
           , updated_at       = NOW()                                                                                                           
       WHERE id = p_id;                                                                                                                         
  END;                                                                                                                                          
  $$;
