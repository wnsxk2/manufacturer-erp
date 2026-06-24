-- 부서 목록 조회                                                                                                                             
-- 선행: 없음                                                                                                                                 
                                                                                                                                                
CREATE OR REPLACE FUNCTION fn_department_list()                                                                                               
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
          d.id                                                                                                                                  
        , d.name                                                                                                                                
        , d.created_at                                                                                                                          
        , d.updated_at                                                                                                                          
      FROM cd_department d                                                                                                                      
      ORDER BY d.id;                                                                                                                            
  END;                                                                                                                                          
  $$;
