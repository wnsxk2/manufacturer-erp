-- 생산 이력 삭제 (재고 차감)                                                                                                                 
-- 선행: sp_inventory_update                                                                                                                  
                                                                                                                                                
CREATE OR REPLACE PROCEDURE sp_production_delete(                                                                                             
    p_id BIGINT                                                                                                                               
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  DECLARE                                                                                                                                       
      v_product_id BIGINT;                                                                                                                      
      v_quantity   INTEGER;                                                                                                                     
  BEGIN                                                                                                                                         
      -- 기존 생산 이력 조회 (행 잠금)                                                                                                          
      SELECT product_id                                                                                                                         
           , quantity                                                                                                                           
        INTO v_product_id                                                                                                                       
           , v_quantity                                                                                                                         
      FROM t_production                                                                                                                         
      WHERE id = p_id                                                                                                                           
      FOR UPDATE;                                                                                                                               
                                                                                                                                                
      -- 재고 차감                                                                                                                              
      CALL sp_inventory_update(                                                                                                                 
          p_product_id => v_product_id                                                                                                          
        , p_quantity_change => -v_quantity                                                                                                      
      );                                                                                                                                        
                                                                                                                                                
      -- 생산 이력 삭제                                                                                                                         
      DELETE FROM t_production                                                                                                                  
       WHERE id = p_id;                                                                                                                         
  END;                                                                                                                                          
  $$;                    
