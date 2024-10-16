-- ************************************************* SPRINT 4 ********************************************************************
-- ------------------------------
-- RODRIGO PADILLA
-- REVISADO POR: JOSEPH TAPIA
-- EJERCICIOS SQL
-- ELEMENTOS Y ANALISIS
-- -------------------------------

SHOW DATABASES;

-- EJERCICIO 1

-- CREATE DATABASE 
DROP DATABASE TRANSACTIONS;

CREATE DATABASE sales;
SHOW DATABASES;

-- CREAR TABLAS
-- Se despliega en el archivo script de Create Tables

-- IMPORTAR CSV 
-- Se despliega en el archivo script de Load CSV

-- PROCEDURE CREA TABLA TEMPORAL
-- Se despliega en archivo script Crea_Detalle_Productos

-- ************************************************* NIVEL 1 *************************************************
-- EJERCICIO 1
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

SELECT CONCAT(U.FIRST_NAME, " ", U.LAST_NAME) NOMBRE_USUARIO, TMP.CUENTA_TRANSAC
FROM USERS U
JOIN 
	(
    SELECT USER_ID, COUNT(TRANSAC_ID) CUENTA_TRANSAC
	FROM TRANSACTIONS
	GROUP BY USER_ID
	HAVING CUENTA_TRANSAC > 30
) TMP
ON U.USER_ID = TMP.USER_ID
ORDER BY 2 DESC;

-- EJERCICIO 2 
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

SELECT CC.IBAN IBAN, PROMEDIO_AMOUNT
FROM CREDIT_CARDS CC
JOIN
	(SELECT T.card_id TC, ROUND(AVG(T.amount),2) PROMEDIO_AMOUNT
	FROM transactions T
						JOIN
							(	SELECT C.COMPANY_ID ID_CIA
								FROM COMPANIES C
								WHERE C.COMPANY_NAME LIKE '%Donec Ltd%'
						) TMP
							ON TMP.ID_CIA = T.BUSINESS_ID
	GROUP BY 1) TMP_B
    ON TMP_B.TC = CC.CARD_ID;
    
    -- ************************************* NIVEL 2 ******************************************************************
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres 
-- transaccions van ser declinades i genera la següent consulta:
-- ¿ Cuantas tarjetas están activas ?

-- EJERCICIO 1
-- Se divide en dos partes, 
-- primero un UPDATE con consultas anidadas para actualizar el estado de las tarjetas que pasa a ser NO ACTIVAS
-- segundo query directo entre tablas

UPDATE CARD_STATES
JOIN			(
				SELECT TEMP.TRANSAC_ID, TEMP.CARD_ID, TEMP.TIMESTAMP_AUD, TEMP.TRANSAC_RANKING, TEMP.DECLINED
				FROM	(	
							SELECT T.TRANSAC_ID,T.CARD_ID, T.DECLINED, T.TIMESTAMP_AUD, 
							DENSE_RANK() OVER(PARTITION BY T.CARD_ID ORDER BY T.TIMESTAMP_AUD DESC) TRANSAC_RANKING
							FROM TRANSACTIONS T) TEMP -- genero ranking para enumerar las transacciones por tarjeta
				WHERE TEMP.TRANSAC_RANKING BETWEEN 1 AND 3
				AND TEMP.CARD_ID IN	
										( SELECT T.CARD_ID  -- Acá solo incluyo tarjetas con al menos 3 transacciones
										FROM TRANSACTIONS T
                                        WHERE T.DECLINED = 1
										GROUP BY 1
										HAVING COUNT(t.transac_id) >= 3)
				) TEMP2 -- A este nivel solo 27 registros que cumplen con 3 transacciones
ON CARD_STATES.CARD_ID = TEMP2.CARD_ID
SET CARD_STATES.CARD_STATUS = 'ACTIVA';

-- una vez actualizada la tabla, se hace la consulta directa
SELECT C.CARD_ID CARD_ID, C.IBAN IBAN, CS.card_status ESTADO
FROM credit_cards C
JOIN card_states CS ON C.CARD_ID = CS.CARD_ID
WHERE CS.card_status = 'NO ACTIVA';

-- **************************************************** NIVEL 3 *****************************************
-- EJERCICIO 1
-- se crea procedimiento que transforma el texto separado por comas en filas

Call Crea_Detalle_Productos();
-- 
SELECT P.PRODUCT_ID ID_PRODUCTO, P.PRODUCT_NAME NOMBRE_PRODUCTO, COUNT(DP.ID_TRANSAC) VECES_VENDIDO
FROM TRANSACTIONS T, TMP_DET_PRODUCTS DP, PRODUCTS P
WHERE T.TRANSAC_ID = DP.ID_TRANSAC
AND DP.ID_PRODUCT = P.PRODUCT_ID 
AND T.DECLINED = 0
GROUP BY 1, 2
ORDER BY 1









