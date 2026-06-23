-- 상품 정보 등록                                                                                                                             
-- 선행: 없음                                                                                                                                 
                                                                                                                                                
CREATE OR REPLACE PROCEDURE sp_product_create(                                                                                                
    p_name  VARCHAR(50)                                                                                                                       
    , p_price INTEGER                                                                                                                           
)                                                                                                                                             
LANGUAGE plpgsql                                                                                                                              
AS $$                                                                                                                                         
  BEGIN                                                                                                                                         
      -- 필수값 검증                                                                                                                         
      IF p_name IS NULL OR TRIM(p_name) = '' THEN                                                                                               
          RAISE EXCEPTION '상품명은 필수입니다.';                                                                                               
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_price IS NULL THEN                                                                                                                   
          RAISE EXCEPTION '가격은 필수입니다.';                                                                                                 
      END IF;                                                                                                                                   
                                                                                                                                                
      IF p_price < 100 THEN                                                                                                                     
          RAISE EXCEPTION '가격은 100원 이상이어야 합니다.';                                                                                    
      END IF;                                                                                                                                   
                                                                                                                                                
      -- 상품 등록                                                                                                                           
      INSERT INTO t_product (                                                                                                                   
          name                                                                                                                                  
        , price                                                                                                                                 
      ) VALUES (                                                                                                                                
          p_name                                                                                                                                
        , p_price                                                                                                                               
      );                                                                                                                                        
  END;                                                                                                                                          
  $$;       
