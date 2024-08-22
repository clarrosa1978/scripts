SET SERVEROUTPUT ON SIZE 999999
SET PAGESIZE 25
SET LINESIZE 300
SET VERIFY OFF
spool &1

DECLARE

	xCTARJNUM	GENCF.T6931000.CTARJNUM%TYPE := 0;
	xCARTINUM	GENCF.T6931000.CARTINUM%TYPE := 0;

	/* Cursor Movimientos de Lista Blanca CLUB la NACION */
	CURSOR curNacion IS
		SELECT CTARJNUM, CARTINUM
		FROM GENCF.T6931000_temp;

BEGIN

	/* Recorrida del cursor */
	FOR recNacion IN curNacion
	LOOP
		/* Variables para LOG de Errores */
		xCTARJNUM := recNacion.CTARJNUM;
		xCARTINUM := recNacion.CARTINUM;

	BEGIN
		/* BAJAS y ALTAS de la LISTA BLANCA */
                IF  (xCARTINUM != 0) 
                THEN
                        INSERT INTO GENCF.T6931000 (CTARJNUM,CARTINUM) VALUES (xCTARJNUM,xCARTINUM);
                        COMMIT;
                ELSIF ( xCARTINUM = 0) 
                THEN
                        DELETE GENCF.T6931000 WHERE CTARJNUM = xCTARJNUM;
                        COMMIT;
                END IF;
                
                EXCEPTION
                WHEN OTHERS THEN
                        DBMS_OUTPUT.PUT_LINE('SALIDA:'||SQLCODE);
                        DBMS_OUTPUT.PUT_LINE('-' || xCTARJNUM);
   
	END;


	END LOOP;

	/* Tratamiento del Error */
	EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('SALIDA:'||SQLCODE);
		DBMS_OUTPUT.PUT_LINE('ERROR EN PROGRAMA --> REGISTRO ERRONEO: ' || xCTARJNUM);

END;
/
spool off
exit;
