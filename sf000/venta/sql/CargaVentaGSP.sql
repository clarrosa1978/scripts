--+------------------------------------------------------------------------------+
--|          COTO - INTERFASE GDM<::>GSP - 					 |
--+---------------+--------------------------------------------------------------+
--| F. Fuente     | CargaVentaGSP.sql                                            |
--+---------------+--------------------------------------------------------------+
--| Descripción   | Este PLSQL se encarga de pasar la venta de GSP a GDM, leyendo|
--|               | la tabla T6043100GSP e insertando en la tabla T6043100ente   |
--+---------------+--------------------------------------------------------------+
--| Programa      | CargaVentaGSP.sql                                            |
--+---------------+-----------------------------------+---------+----------------+
--| Aplicación    | PLSQL - SUC00                  | Entorno | Servidor          |
--+---------------+-------------------------+---------+---------+----------------+
--| Creado por    | Jose Chariano           | Fecha de creación | 21/09/2004     |
--+---------------+-------------------------+-------------------+----------------+
--| Ult. mod.     |                                                              |
--+---------------+--------------------------------------------------------------+
--| Objetos       |               						 |
--| Públicos      |								 |
--| del módulo    |                                                              |
--+---------------+--------------------------------------------------------------+
--| Dependencias  |                                                              |
--+---------------+--------------------------------------------------------------+
/* Variables del SQLPLUS */
set feed off
set termout on
set serveroutput on
spool &1
DECLARE
	/* Definicion de Variables */
	XCTERMINL                VARCHAR2(8);
	XNCTRTERM                VARCHAR2(8);
	XCEMPRESA                NUMBER(2);
	XCNCENTRO                NUMBER(3);
	XFCTRENTR                CHAR(8);
	XHCTRENTR                VARCHAR2(6);
	XCTIPVENT                CHAR(3);
	XXARTENVA                CHAR(1);
	XCDEPARTM                NUMBER(3);
	XCARTREFE                NUMBER(15);
	XQLTMEDID                NUMBER(10,3);
	XILTRIMPO                NUMBER(11,2);
	XCOFERART                NUMBER(6);
	XIDESOFAR                NUMBER(11,2);
	XCOFERDEP                NUMBER(6);
	XIDESOFDP                NUMBER(11,2);
	XIDESCOTR                NUMBER(11,2);
	XIDESCEMP                NUMBER(11,2);
	XXREGPROC                NUMBER(1);
	XCPROMART                NUMBER(6);
	XIDESPRAR                NUMBER(11,2);
	XCPROMDEP                NUMBER(6);
	XIDESPRDP                NUMBER(11,2);
	XFECHAMOV                CHAR(8);
	XXESTLINE                VARCHAR2(1);
	xregistro		    	 NUMBER(8);
	xnumregis			 NUMBER(8);
	xregmaxim			 NUMBER(8);
	/* Generacion del Cursor con los datos de Venta*/
	CURSOR curGSP IS
  		SELECT CTERMINL, NCTRTERM, CEMPRESA, CNCENTRO, FCTRENTR,
			HCTRENTR, CTIPVENT, XARTENVA, CDEPARTM, CARTREFE,
			QLTMEDID, ILTRIMPO, COFERART, IDESOFAR, COFERDEP,
			IDESOFDP, IDESCOTR, IDESCEMP, XREGPROC, CPROMART,
			IDESPRAR, CPROMDEP, IDESPRDP, FECHAMOV
		FROM T6043100GSP
		WHERE XESTLINE != 'S'
		ORDER by CTERMINL, NCTRTERM, CEMPRESA, CNCENTRO, FCTRENTR
		FOR UPDATE OF XESTLINE;
BEGIN
	/* Inicializacion de Variables */
	xregistro:=0;
    xnumregis:=0;
	xregmaxim:=15000;	/* Cantidad máxima de registros */
	/* Apertura del Cursor */
	OPEN curGSP;
	    /* Recorre el cursor para hacer COMMIT parciales */
		LOOP
    	    /* Asigna el registro del cursos a las variables */
			FETCH curGSP
			INTO XCTERMINL, XNCTRTERM, XCEMPRESA, XCNCENTRO, XFCTRENTR,
				XHCTRENTR, XCTIPVENT, XXARTENVA, XCDEPARTM, XCARTREFE,
				XQLTMEDID, XILTRIMPO, XCOFERART, XIDESOFAR, XCOFERDEP,
				XIDESOFDP, XIDESCOTR, XIDESCEMP, XXREGPROC, XCPROMART,
				XIDESPRAR, XCPROMDEP, XIDESPRDP, XFECHAMOV;
	        /* Finaliza la carga cuando se terminan los registros */
			EXIT WHEN curGSP%notfound;
			/* Cuanta la cantidad de registro procesados */
			xregistro:=xregistro+1;
			/* Condicion para COMMIT parciales */
			IF (xregistro=xregmaxim)
			THEN
				/* Confirma los ultimos N registros modificados */
				xregistro:=0;
				xnumregis:=xnumregis+xregmaxim;
				DBMS_OUTPUT.PUT_LINE('SALIDA:'||SQLCODE);
				DBMS_OUTPUT.PUT_LINE('Registros procesados: '||xnumregis);
				/* commit; COMENTADO PARA ACELERAR EL INSERT */
			END IF;
	        /* Ejecuta la actualizacion del registro */
			INSERT INTO T6043100 (CTERMINL, NCTRTERM, CEMPRESA, CNCENTRO, FCTRENTR,
							HCTRENTR, CTIPVENT, XARTENVA, CDEPARTM, CARTREFE,
							QLTMEDID, ILTRIMPO, COFERART, IDESOFAR, COFERDEP,
							IDESOFDP, IDESCOTR, IDESCEMP, XREGPROC, CPROMART,
							IDESPRAR, CPROMDEP, IDESPRDP, FECHAMOV)
			VALUES (XCTERMINL, XNCTRTERM, XCEMPRESA, XCNCENTRO, XFCTRENTR,
				XHCTRENTR, XCTIPVENT, XXARTENVA, XCDEPARTM, XCARTREFE,
				XQLTMEDID, XILTRIMPO, XCOFERART, XIDESOFAR, XCOFERDEP,
				XIDESOFDP, XIDESCOTR, XIDESCEMP, XXREGPROC, XCPROMART,
				XIDESPRAR, XCPROMDEP, XIDESPRDP, XFECHAMOV);
		/* Actualiza el registro leido para la proxima corrida */
			UPDATE T6043100GSP 
			SET XESTLINE = 'S'
			WHERE CURRENT OF curGSP;
		END LOOP;
	    /* Confirma los registros modificados menores a N */
		xnumregis:=xnumregis+xregistro;
		DBMS_OUTPUT.PUT_LINE('SALIDA:'||SQLCODE);
	    DBMS_OUTPUT.PUT_LINE('Registros procesados: '||xnumregis);
	    commit;
    CLOSE curGSP;
	/* Salida por errores no manejados */
	EXCEPTION
	WHEN OTHERS THEN
		ROLLBACK;
		DBMS_OUTPUT.PUT_LINE('SALIDA:'||SQLCODE);	
		DBMS_OUTPUT.PUT_LINE('ERROR EN REGISTRO: '||xnumregis||' Centro: '||xcncentro||' Trmn: '||xcterminl ||' Trx: '||xnctrterm);
END;
/
spool off
quit
