-- 상품 재고 수량 변경                                                                                                                        
-- 선행: 없음   
CREATE OR REPLACE PROCEDURE sp_inventory_update(                                                                                              
    p_product_id      BIGINT                                                                                                                  
    , p_quantity_change INTEGER                                                                                                                 
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  DECLARE                                                                                                                                       
      v_current_stock INTEGER;                                                                                                                  
  BEGIN                                                                                                                                         
      -- 재고 조회 (행 잠금)                                                                                                                    
      SELECT stock_quantity                                                                                                                     
        INTO v_current_stock                                                                                                                    
      FROM t_inventory                                                                                                                          
      WHERE product_id = p_product_id                                                                                                           
      FOR UPDATE;                                                                                                                               
                                                                                                                                                
      -- 재고 업데이트                                                                                                                          
      UPDATE t_inventory                                                                                                                        
         SET stock_quantity = stock_quantity + p_quantity_change                                                                                
           , updated_at = NOW()                                                                                                                 
       WHERE product_id = p_product_id;                                                                                                         
  END;                 
  $$
