-- 직급 목록 조회                                                                                                                             
-- 선행: 없음                                                                                                                                 
                                                                                                                                                
CREATE OR REPLACE FUNCTION fn_employee_rank_list()                                                                                            
RETURNS TABLE(                                                                                                                                
    id         VARCHAR                                                                                                                        
    , name       VARCHAR                                                                                                                        
    , created_at TIMESTAMPTZ                                                                                                                    
    , updated_at TIMESTAMPTZ                                                                                                                    
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  BEGIN                                                                                                                                         
      RETURN QUERY                                                                                                                              
      SELECT                                                                                                                                    
          r.id                                                                                                                                  
        , r.name                                                                                                                                
        , r.created_at                                                                                                                          
        , r.updated_at                                                                                                                          
      FROM cd_employee_rank r                                                                                                                   
      ORDER BY r.id;                                                                                                                            
  END;   
    $$;           
