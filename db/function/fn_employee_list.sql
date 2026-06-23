-- 사원 목록 조회 (사원명 검색 포함)                                                                                                            
-- 선행: 없음                                                                                                 
                                                                                                                                                
CREATE OR REPLACE FUNCTION fn_employee_list(                                                                                                  
    p_name VARCHAR(20) DEFAULT NULL                                                                                                           
)                                                                                                                                             
RETURNS TABLE(                                                                                                                                
    id                 BIGINT                                                                                                                 
    , department_id      VARCHAR                                                                                                                
    , department_name    VARCHAR                                                                                                                
    , employee_rank_id   VARCHAR                                                                                                                
    , employee_rank_name VARCHAR                                                                                                                
    , name               VARCHAR                                                                                                                
    , rrn                VARCHAR                                                                                                                
    , address            VARCHAR                                                                                                                
    , start_date         TIMESTAMPTZ                                                                                                            
    , resignation_date   TIMESTAMPTZ                                                                                                            
    , is_active          BOOLEAN                                                                                                                
    , created_at         TIMESTAMPTZ                                                                                                            
    , updated_at         TIMESTAMPTZ                                                                                                            
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  BEGIN                                                                                                                                         
      RETURN QUERY                                                                                                                              
      SELECT                                                                                                                                    
          e.id                                                                                                                                  
        , e.department_id                                                                                                                       
        , d.name AS department_name                                                                                                             
        , e.employee_rank_id                                                                                                                    
        , r.name AS employee_rank_name                                                                                                          
        , e.name                                                                                                                                
        , e.rrn                                                                                                                                 
        , e.address                                                                                                                             
        , e.start_date                                                                                                                          
        , e.resignation_date                                                                                                                    
        , e.is_active                                                                                                                           
        , e.created_at                                                                                                                          
        , e.updated_at                                                                                                                          
      FROM t_employee e                                                                                                                         
      LEFT JOIN cd_department d ON d.id = e.department_id                                                                                       
      JOIN cd_employee_rank r ON r.id = e.employee_rank_id                                                                                      
      WHERE (p_name IS NULL OR e.name ILIKE '%' || p_name || '%')                                                                               
      ORDER BY e.id;                                                                                                                            
  END;                                                                                                                                          
  $$;     
