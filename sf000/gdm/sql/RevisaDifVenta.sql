--+------------------------------------------------------------------------------+
--|          COTO - INTERFASE de CONTROL DE VENTAS   -          |
--+---------------+--------------------------------------------------------------+
--| F. Fuente     | RevisaDifventa.sql			                                 |
--+---------------+--------------------------------------------------------------+
--| Descripci�n   | Este PLSQL se encarga de controlar que no existan diferencias|
--|               | entre G.D.M y el total que figura en el listado LS001002.    |
--+---------------+--------------------------------------------------------------+
--| Programa      | RevisaDifVenta.sql                                          |
--+---------------+-----------------------------------+---------+----------------+
--| Aplicaci�n    | PLSQL - SUC00                  | Entorno | Servidor          |
--+---------------+-------------------------+---------+---------+----------------+
--| Creado por    | Jose Chariano           | Fecha de creaci�n | 17/10/2008     |
--+---------------+-------------------------+-------------------+----------------+
--| Ult. mod.     | Claudio Polo 01/11/2012 
--+---------------+--------------------------------------------------------------+
--| Objetos       |               											     |
--| P�blicos      |															     |
--| del m�dulo    |                                                              |
--+---------------+--------------------------------------------------------------+
--| Dependencias  |                                                              |
--+---------------+--------------------------------------------------------------+

/* Variables del SQLPLUS */
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK ON
SET LINES 100
SPOOL &1 
set timing on
set serveroutput on size 999999 

DECLARE
	
	/* Definicion de Variables */
    xcncentro			varchar2(3);
    xitottran			number(11,2) := 0; /* Total de Transaccion SF	*/
	xitottrps			number(11,2) := 0; /* Total de Transaccion GDM	*/
	xitottgsp			number(11,2) := 0; /* Total de Transaccion GSP	*/
	xitotdife			number(11,2); /* Total de Transaccion		*/
	xfprocier			varchar2(8);  /* Fecha de proceso			*/
	xregistro			number(9);
    
	/* Generacion del Cursor con los datos de la T7790000 */
	CURSOR curDifVenta IS
			SELECT CCENINGE, ITOTDPTO, FRCTPROC
			FROM T7790000
			WHERE FRCTPROC = TO_CHAR(sysdate-1,'YYYYMMDD');

	CURSOR curGSP (sucursal VARCHAR2, fecha VARCHAR2) IS
			SELECT DECODE(CTIPVENT,'VEN',ILTRIMPO,-ILTRIMPO) VENTA
			FROM T6043100gsp
			WHERE CEMPRESA = 2 AND FCTRENTR = fecha AND CNCENTRO = sucursal AND XESTLINE = 'S';

BEGIN  
	/* Inicializacion de Variables */
	xregistro:=0;

	/* Salida standard para reportes - CABECERA */
	DBMS_OUTPUT.PUT_LINE(' ---------------------------------------------------------');
	DBMS_OUTPUT.PUT_LINE(' -- CONTROL DE INTEGRIDAD ENTRE LS001007 Y T9695390 GDM -- ');
	DBMS_OUTPUT.PUT_LINE(' --');
	DBMS_OUTPUT.PUT_LINE(' --');
		
	/* Apertura del Cursor */
	OPEN curDifVenta;

	    /* Recorre el cursor para armar el reporte por Sucursal */
		LOOP

    	    /* Asigna el registro del cursos a las variables */
			FETCH curDifVenta
			INTO xcncentro, xitottrps, xfprocier;

	        /* Finaliza la carga cuando se terminan los registros */
			EXIT WHEN curDifVenta%notfound;

			/* Cuanta la cantidad de registro procesados */
			xregistro:=xregistro+1;

			/* Obtiene el total de GDM */		
				SELECT /*+ INDEX (T9695390 I9695390) */
				NVL(SUM(DECODE(CTIPVENT,'VEN',ILTRIMPO,-ILTRIMPO)),0) INTO xitottran
				FROM T9695390
				WHERE CEMPRESA = 1 AND CNCENTRO = xcncentro AND FCTRENTR = xfprocier;

			/* Obtiene los totales de Venta de Game System y Cines */
			FOR recGSP IN curGSP (xcncentro, xfprocier) 
			LOOP
				xitottgsp := recGSP.VENTA;
			END LOOP;		

			/* Diferencia entre totales */
			xitotdife := TO_NUMBER(xitottran) - TO_NUMBER(xitottrps) - TO_NUMBER(xitottgsp) ;
			
			/* IF xitotdife >= -100 and xitotdife <= 100 */
			IF xitotdife <> 0 
			THEN
				/* Salida standard para reportes - LINEAS */
				DBMS_OUTPUT.PUT_LINE(' SUC: ' || LPAD(xcncentro,3,'0') || '	SF: ' || xitottrps || '	GDM: ' || xitottran || '	GSP: ' || xitottgsp ||	'	DIF: ' || xitotdife );		
			END IF;

	    END LOOP;

    CLOSE curDifVenta;

	
	/* Salida standard para reportes - LINEAS */
	DBMS_OUTPUT.PUT_LINE(' --');
	DBMS_OUTPUT.PUT_LINE(' --');
	DBMS_OUTPUT.PUT_LINE(' --');
	DBMS_OUTPUT.PUT_LINE(' -- FIN DE REPORTE, CANTIDAD DE REGISTROS PROCESADOS: ' || xregistro );
	DBMS_OUTPUT.PUT_LINE(' --        FECHA DE PROCESO: ' || xfprocier );                   
	DBMS_OUTPUT.PUT_LINE(' --');

	/* Salida por errores no manejados */
	EXCEPTION
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('SALIDA:'||SQLCODE);
		DBMS_OUTPUT.PUT_LINE('ERROR EN REGISTRO: '|| xregistro ||' Centro: '||xcncentro);
END;

/

quit;
