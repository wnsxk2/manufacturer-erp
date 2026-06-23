-- 사원 정보 등록                                                                                                                             
-- 선행: ddl/01_create_table.sql                                                                                                              
                                                                                                                                                
CREATE OR REPLACE PROCEDURE sp_employee_create(                                                                                               
    p_department_id    VARCHAR(5) DEFAULT NULL                                                                                                
    , p_employee_rank_id VARCHAR(5)                                                                                                             
    , p_name             VARCHAR(20)                                                                                                            
    , p_rrn              VARCHAR(14)                                                                                                            
    , p_address          VARCHAR(100)                                                                                                           
    , p_start_date       TIMESTAMPTZ                                                                                                            
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
BEGIN                                                                                                                                         
    -- 필수값 검증                                                                                                                         
    IF p_employee_rank_id IS NULL OR TRIM(p_employee_rank_id) = '' THEN                                                                       
        RAISE EXCEPTION '직급은 필수입니다.';                                                                                                 
    END IF;                                                                                                                                   
                                                                                                                                            
    IF p_name IS NULL OR TRIM(p_name) = '' THEN                                                                                               
        RAISE EXCEPTION '사원명은 필수입니다.';                                                                                               
    END IF;                                                                                                                                   
                                                                                                                                            
    IF p_rrn IS NULL OR TRIM(p_rrn) = '' THEN                                                                                                 
        RAISE EXCEPTION '주민등록번호는 필수입니다.';                                                                                         
    END IF;                                                                                                                                   
                                                                                                                                            
    -- 주민등록번호 포맷 검증 (XXXXXX-XXXXXXX)                                                                                             
    IF p_rrn !~ '^\d{6}-\d{7}$' THEN                                                                                                          
        RAISE EXCEPTION '주민등록번호 형식이 올바르지 않습니다. (예: 000101-1234567)';                                                        
    END IF;                                                                                                                                   
                                                                                                                                            
    IF p_address IS NULL OR TRIM(p_address) = '' THEN                                                                                         
        RAISE EXCEPTION '주소는 필수입니다.';                                                                                                 
    END IF;                                                                                                                                   
                                                                                                                                            
    IF p_start_date IS NULL THEN                                                                                                              
        RAISE EXCEPTION '입사일은 필수입니다.';                                                                                               
    END IF;                                                                                                                                   
                                                                                                                                                                                                                                                                         
                                                                                                                                            
    -- 사원 등록                                                                                                                           
    INSERT INTO t_employee (                                                                                                                  
        department_id                                                                                                                         
    , employee_rank_id                                                                                                                      
    , name                                                                                                                                  
    , rrn                                                                                                                                   
    , address                                                                                                                               
    , start_date                                                                                                                            
    ) VALUES (                                                                                                                                
        p_department_id                                                                                                                       
    , p_employee_rank_id                                                                                                                    
    , TRIM(p_name)                                                                                                                          
    , p_rrn                                                                                                                                 
    , TRIM(p_address)                                                                                                                       
    , p_start_date                                                                                                                          
    );                                                                                                                                        
END;                                                                                                                                          
$$;       
