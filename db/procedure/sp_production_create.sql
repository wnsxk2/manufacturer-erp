-- 상품 생산 등록                                                                                                                           
-- 선행: sp_inventory_restock.sql                                                                                                           
                                                                                                                                              
CREATE OR REPLACE PROCEDURE sp_production_create(                                                                                           
    p_employee_id BIGINT                                                                                                                    
    , p_product_id  BIGINT                                                                                                                    
    , p_quantity    INTEGER                                                                                                                   
    , p_produced_at TIMESTAMPTZ DEFAULT NOW()                                                                                                 
)                                                                                                                                           
LANGUAGE plpgsql                                                                                                                            
AS $$                                                                                                                                       
  DECLARE                                                                                                                                     
      v_employee_active BOOLEAN;                                                                                                              
      v_product_active  BOOLEAN;                                                                                                              
  BEGIN                                                                                                                                       
      -- 필수값 검증                                                                                                                       
      IF p_employee_id IS NULL THEN                                                                                                           
          RAISE EXCEPTION '사원 ID는 필수입니다.';                                                                                            
      END IF;                                                                                                                                 
                                                                                                                                              
      IF p_product_id IS NULL THEN                                                                                                            
          RAISE EXCEPTION '상품 ID는 필수입니다.';                                                                                            
      END IF;                                                                                                                                 
                                                                                                                                              
      IF p_quantity IS NULL THEN                                                                                                              
          RAISE EXCEPTION '수량은 필수입니다.';                                                                                               
      END IF;                                                                                                                                 
                                                                                                                                              
      IF p_quantity < 1 THEN                                                                                                                  
          RAISE EXCEPTION '수량은 1 이상이어야 합니다.';                                                                                      
      END IF;                                                                                                                                 
                                                                                                                                              
      -- 사원 존재 및 재직 여부 확인                                                                                                       
      SELECT is_active                                                                                                                        
        INTO v_employee_active                                                                                                                
        FROM t_employee                                                                                                                       
       WHERE id = p_employee_id;                                                                                                              
                                                                                                                                              
      IF v_employee_active IS NULL THEN                                                                                                       
          RAISE EXCEPTION '존재하지 않는 사원입니다. employee_id: %', p_employee_id;                                                          
      END IF;                                                                                                                                 
                                                                                                                                              
      IF NOT v_employee_active THEN                                                                                                           
          RAISE EXCEPTION '퇴사한 사원은 생산 등록할 수 없습니다. employee_id: %', p_employee_id;                                             
      END IF;                                                                                                                                 
                                                                                                                                              
      -- 상품 존재 및 활성 여부 확인                                                                                                       
      SELECT is_active                                                                                                                        
        INTO v_product_active                                                                                                                 
        FROM t_product                                                                                                                        
       WHERE id = p_product_id;                                                                                                               
                                                                                                                                              
      IF v_product_active IS NULL THEN                                                                                                        
          RAISE EXCEPTION '존재하지 않는 상품입니다. product_id: %', p_product_id;                                                            
      END IF;                                                                                                                                 
                                                                                                                                              
      IF NOT v_product_active THEN                                                                                                            
          RAISE EXCEPTION '비활성 상품은 생산할 수 없습니다. product_id: %', p_product_id;                                                    
      END IF;                                                                                                                                 
                                                                                                                                              
      -- 생산 등록                                                                                                                         
      INSERT INTO t_production (                                                                                                              
          employee_id                                                                                                                         
        , product_id                                                                                                                          
        , quantity                                                                                                                            
        , produced_at                                                                                                                         
      ) VALUES (                                                                                                                              
          p_employee_id                                                                                                                       
        , p_product_id                                                                                                                        
        , p_quantity                                                                                                                          
        , p_produced_at                                                                                                                       
      );                                                                                                                                      
                                                                                                                                              
      -- 재고 추가                                                                                                                         
      CALL sp_inventory_restock(                                                                                                              
          p_product_id => p_product_id                                                                                                        
        , p_quantity   => p_quantity                                                                                                          
      );                                                                                                                                      
  END;                                                                                                                                        
  $$; 
