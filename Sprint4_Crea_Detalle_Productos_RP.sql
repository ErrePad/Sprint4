-- ****************************************************************************************
-- * PROCEDURE QUE LEE UN STRING QUE CONTIENE COMAS Y POR CADA UNA, GENERA UNA FILA(ROW)  *
-- * PROCEDIMIENTO DEPURADO DE CURSORES PARA SPRINT4 EN DATA ANALYST IT ACADEMY           *
-- ****************************************************************************************
DELIMITER $$

$$
CREATE PROCEDURE Crea_Detalle_Productos()
BEGIN
	  
-- variables para el control de la palabra 
DECLARE var_caracter VARCHAR(1);
DECLARE var_cont INT default 1;
DECLARE var_cont_mini INT default 0;
DECLARE var_parte_texto VARCHAR(100);
DECLARE var_pasa_palabra VARCHAR(100);
DECLARE var_largo int;
 
 -- variables para el cursor
DECLARE varID_PRODUCT VARCHAR(100);
DECLARE varID_TRANSAC VARCHAR(100);
DECLARE varTIMESTAMP_TRANSAC VARCHAR(100);
-- DECLARE varAMOUNT_TRANSAC FLOAT;

DECLARE varFIN INT DEFAULT 0;

DECLARE cursor1 CURSOR FOR
	SELECT PRODUCT_IDS,TRANSAC_ID, TIMESTAMP_AUD
    FROM TRANSACTIONS
   -- WHERE DECLINED = 0
    ORDER BY TIMESTAMP_AUD DESC;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET varFIN = 1;
--
-- Limpiamos desde cero la tabla tmp_detalle_products
DROP TABLE IF EXISTS tmp_detalle_products;

CREATE TABLE 
        tmp_det_products
		(	id_product VARCHAR(100),
			id_transac VARCHAR(100),
			timestamp_created VARCHAR(50)
		);
        
-- ---------------------------------------------------

OPEN cursor1;

myLoop: LOOP

	FETCH cursor1 INTO varID_PRODUCT, varID_TRANSAC, varTIMESTAMP_TRANSAC; -- avanzo por cada registro de mi SELECT de cursor1
    
		IF varFIN = 1 THEN
			LEAVE myloop;
		END IF;
 
				set var_pasa_palabra = varID_PRODUCT;
				set var_largo = length(var_pasa_palabra);
				
				WHILE var_cont <= var_largo DO -- recorremos la palabra que contiene los IDs separado por comas
				
					SET var_caracter = substring(var_pasa_palabra, var_cont, 1);
					
						IF var_caracter = ',' THEN -- llegamos a la coma por tanto, separamos, limpiamos e INSERT
								set var_parte_texto = substring(var_pasa_palabra, var_cont - var_cont_mini, var_cont_mini);
								set var_parte_texto = REPLACE(var_parte_texto, ',', ' ');
								set var_parte_texto = RTRIM(var_parte_texto);
								
								INSERT INTO tmp_det_products
									VALUES (TRIM(var_parte_texto), varID_TRANSAC, concat(varTIMESTAMP_TRANSAC,' -- ', NOW()));
								set	var_cont_mini = 0;
						ELSE
							IF var_cont = var_largo THEN -- ultima separación, no gatilla el insert la coma, sino el final
								set var_parte_texto = substring(var_pasa_palabra, var_cont - var_cont_mini, var_cont_mini + 1);
								set var_parte_texto = REPLACE(var_parte_texto, ',', ' ');
								set var_parte_texto = RTRIM(var_parte_texto);
                                
								INSERT INTO tmp_det_products
									VALUES (TRIM(var_parte_texto), varID_TRANSAC, concat(varTIMESTAMP_TRANSAC,' -- ', NOW()));
							END IF;
						END IF;
                        
					set var_cont =  var_cont + 1; -- cuento el avance por la palabra
					set var_cont_mini = var_cont_mini + 1; -- cuento el avance por la parte del ID
	
				END WHILE;
                
				SET var_cont = 1; -- reiniciamos por pasar a otro registro
                SET var_cont_mini = 0; -- reiniciamos por pasar a otro registro

END LOOP myLoop;

CLOSE cursor1;

END$$

DELIMITER ;

CALL Crea_Detalle_Productos();

-- XX   ELIMINA  XX --
DROP PROCEDURE CREA_DETALLE_PRODUCTOS;
DROP TABLE tmp_detalle_products


