CREATE OR REPLACE PROCEDURE sp_inventory_restock(                                                                                           
    p_product_id BIGINT                                                                                                                     
    , p_quantity   INTEGER                                                                                                                    
)                                                                                                                                           
LANGUAGE plpgsql                                                                                                                            
AS $$                                                                                                                                       
  DECLARE                                                                                                                                     
      v_exists BOOLEAN;                                                                                                                       
  BEGIN                                                                                                                                       
      -- 필수값 검증                                                                                                                       
      IF p_product_id IS NULL THEN                                                                                                            
          RAISE EXCEPTION '상품 ID는 필수입니다.';                                                                                            
      END IF;                                                                                                                                 
                                                                                                                                              
      IF p_quantity IS NULL THEN                                                                                                              
          RAISE EXCEPTION '수량은 필수입니다.';                                                                                               
      END IF;                                                                                                                                 
                                                                                                                                              
      IF p_quantity < 1 THEN                                                                                                                  
          RAISE EXCEPTION '수량은 1 이상이어야 합니다.';                                                                                      
      END IF;                                                                                                                                 
                                                                                                                                              
      -- 재고 존재 여부 확인                                                                                                               
      SELECT EXISTS (                                                                                                                         
          SELECT 1 FROM t_inventory WHERE product_id = p_product_id                                                                           
      ) INTO v_exists;                                                                                                                        
                                                                                                                                              
      -- 없으면 INSERT, 있으면 UPDATE                                                                                                      
      IF v_exists THEN                                                                                                                        
          UPDATE t_inventory                                                                                                                  
             SET stock_quantity = stock_quantity + p_quantity                                                                                 
               , updated_at     = NOW()                                                                                                       
           WHERE product_id = p_product_id;                                                                                                   
      ELSE                                                                                                                                    
          INSERT INTO t_inventory (                                                                                                           
              product_id                                                                                                                      
            , stock_quantity                                                                                                                  
          ) VALUES (                                                                                                                          
              p_product_id                                                                                                                    
            , p_quantity                                                                                                                      
          );                                                                                                                                  
      END IF;                                                                                                                                 
  END;                                                                                                                                        
  $$;                        
