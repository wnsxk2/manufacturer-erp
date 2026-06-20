CREATE OR REPLACE FUNCTION fn_customer_list(                                                       
    p_name VARCHAR(50) DEFAULT NULL                                                                
)                                                                                                  
RETURNS TABLE(                                                                                     
    id            BIGINT                                                                           
    , name          VARCHAR                                                                          
    , address       VARCHAR                                                                          
    , contract_date TIMESTAMPTZ                                                                      
    , is_active     BOOLEAN                                                                          
    , created_at    TIMESTAMPTZ                                                                      
    , updated_at    TIMESTAMPTZ                                                                      
)                                                                                                  
LANGUAGE plpgsql                                                                                   
AS $$                                                                                              
  BEGIN                                                                                              
      RETURN QUERY                                                                                   
      SELECT                                                                                         
          c.id                                                                                       
        , c.name                                                                                     
        , c.address                                                                                  
        , c.contract_date                                                                            
        , c.is_active                                                                                
        , c.created_at                                                                               
        , c.updated_at                                                                               
      FROM t_customer c                                                                              
      WHERE (p_name IS NULL OR c.name ILIKE '%' || p_name || '%')                                    
      ORDER BY c.id;                                                                                 
  END;                                                                                               
  $$;                          
