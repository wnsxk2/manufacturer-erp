-- 생산 이력 수량 수정 (재고 연동)                                                                                                            
-- 선행: sp_inventory_update                                                                                                                  
                                                                                                                                                
CREATE OR REPLACE PROCEDURE sp_production_update(                                                                                             
    p_id       BIGINT                                                                                                                         
    , p_quantity INTEGER                                                                                                                        
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  DECLARE                                                                                                                                       
      v_product_id       BIGINT;                                                                                                                
      v_current_quantity INTEGER;                                                                                                               
      v_quantity_diff    INTEGER;                                                                                                               
  BEGIN                                                                                                                                         
      -- 기존 생산 이력 조회 (행 잠금)                                                                                                          
      SELECT product_id                                                                                                                         
           , quantity                                                                                                                           
        INTO v_product_id                                                                                                                       
           , v_current_quantity                                                                                                                 
      FROM t_production                                                                                                                         
      WHERE id = p_id                                                                                                                           
      FOR UPDATE;                                                                                                                               
                                                                                                                                                
      -- 수량 차이 계산                                                                                                                         
      v_quantity_diff := p_quantity - v_current_quantity;                                                                                       
                                                                                                                                                
      -- 재고 조정                                                                                                                              
      CALL sp_inventory_update(                                                                                                                 
          p_product_id => v_product_id                                                                                                          
        , p_quantity_change => v_quantity_diff                                                                                                  
      );                                                                                                                                        
                                                                                                                                                
      -- 생산 이력 업데이트                                                                                                                     
      UPDATE t_production                                                                                                                       
         SET quantity = p_quantity                                                                                                              
           , updated_at = NOW()                                                                                                                 
       WHERE id = p_id;                                                                                                                         
  END;                                                                                                                                          
  $$;                
