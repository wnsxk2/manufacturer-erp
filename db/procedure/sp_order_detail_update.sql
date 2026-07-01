-- 주문 상세 정보 변경 (수량)                                                                    
-- 선행: 없음                                                                                    
                                                                                                   
CREATE OR REPLACE PROCEDURE sp_order_detail_update(                                              
    p_id       BIGINT                                                                            
    , p_quantity INTEGER                                                                           
)                                                                                                
LANGUAGE plpgsql                                                                                 
AS $$                                                                                            
  BEGIN                                                                                            
      -- 주문 조회 (행 잠금)                                                                       
      PERFORM 1                                                                                    
      FROM t_product_order                                                                         
      WHERE id = p_id                                                                              
      FOR UPDATE;                                                                                  
                                                                                                   
      -- 수량 변경                                                                                 
      UPDATE t_product_order                                                                       
         SET quantity   = p_quantity                                                               
           , updated_at = NOW()                                                                    
       WHERE id = p_id;                                                                            
  END;                                                                                             
  $$;       
