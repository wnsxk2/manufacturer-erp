-- 주문 상태 수정 (ORDERED → SHIPPED 시 재고 차감)                                               
-- 선행: sp_inventory_update                                                                     
                                                                                                   
CREATE OR REPLACE PROCEDURE sp_order_update(                                                     
    p_id           BIGINT                                                                        
    , p_order_status VARCHAR(20)                                                                   
)                                                                                                
LANGUAGE plpgsql                                                                                 
AS $$                                                                                            
  DECLARE                                                                                          
      v_current_status VARCHAR(20);                                                                
      v_product_id     BIGINT;                                                                     
      v_quantity       INTEGER;                                                                    
  BEGIN                                                                                            
      -- 주문 조회 (행 잠금)                                                                       
      SELECT order_status                                                                          
           , product_id                                                                            
           , quantity                                                                              
        INTO v_current_status                                                                      
           , v_product_id                                                                          
           , v_quantity                                                                            
      FROM t_product_order                                                                         
      WHERE id = p_id                                                                              
      FOR UPDATE;                                                                                  
                                                                                                   
      -- ORDERED → SHIPPED 변경 시 재고 차감                                                       
      IF v_current_status = 'ORDERED' AND p_order_status = 'SHIPPED' THEN                          
          CALL sp_inventory_update(                                                                
              p_product_id      => v_product_id                                                    
            , p_quantity_change => -v_quantity                                                     
          );                                                                                       
      END IF;                                                                                      
                                                                                                   
      -- 상태 변경                                                                                 
      UPDATE t_product_order                                                                       
         SET order_status = p_order_status                                                         
           , updated_at   = NOW()                                                                  
       WHERE id = p_id;                                                                            
  END;                                                                                             
  $$;
