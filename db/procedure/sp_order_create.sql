-- 상품 주문 등록                                                             
-- 선행: sp_inventory_update                                                                                                                                                 
CREATE OR REPLACE PROCEDURE sp_order_create(                                                     
    p_customer_id BIGINT                                                                         
    , p_product_id  BIGINT                                                                         
    , p_quantity    INTEGER                                                                        
    , p_ordered_at  TIMESTAMPTZ DEFAULT NOW()                                                      
)                                                                                                
LANGUAGE plpgsql                                                                                 
AS $$                                                                                            
BEGIN                                                                                            
    -- 재고 조회 (행 잠금)                                                                       
    PERFORM 1                                                                                    
    FROM t_inventory                                                                             
    WHERE product_id = p_product_id                                                              
    FOR UPDATE;                                                                                  
                                                                                                
    -- 재고 차감                                                                                 
    CALL sp_inventory_update(                                                                    
        p_product_id      => p_product_id                                                        
    , p_quantity_change => -p_quantity                                                         
    );                                                                                           
                                                                                                
    -- 주문 등록                                                                                 
    INSERT INTO t_product_order (                                                                
        customer_id                                                                              
    , product_id                                                                               
    , quantity                                                                                 
    , order_status                                                                             
    , ordered_at                                                                               
    ) VALUES (                                                                                   
        p_customer_id                                                                            
    , p_product_id                                                                             
    , p_quantity                                                                               
    , 'ORDERED'                                                                                
    , p_ordered_at                                                                             
    );                                                                                           
END;                                                                                             
$$;                              
