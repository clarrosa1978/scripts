--+-------------------------------------------------------------------------+
--| COTO - INTERFACE PIM->SIT                                               |
--+---------------+---------------------------------------------------------+
--| F. Fuente     | IntPIMSIT.sql                                           |
--+---------------+---------------------------------------------------------+
--| Descripción   | Este PLSQL se encarga de insertar los movimientos de    |
--|               | billetera PIM en la tabla TI_HA de SIT                  |
--+---------------+---------------------------------------------------------+
--| Programa      | IntPIMSIT.sql                                           |
--+---------------+-----------------------------------+---------+-----------+
--| Aplicación    | PLSQL                             | Entorno | Servidor  |
--+---------------+-------------------------+---------+---------+-----------+
--| Creado por    | DSama                   | Fecha de creación | Ene 2018  |
--+---------------+-------------------------+-------------------+-----------+
--| Ult. mod.     | Tk#117620 Creado. Billetera PIM (asociado #127791)      |
--+---------------+---------------------------------------------------------+

/* Variables del SQLPLUS */
set echo off
set timing on
set serveroutput on size 999999
SET ECHO OFF

SET VERIFY OFF
SET TERMOUT ON
SET FEED OFF

spool &1

DECLARE

	/* Definicion de Variables */
	xCTRANSAC	T8000100.CTRANSAC%TYPE;
	xCDOCUMEN	T8000100.CDOCUMEN%TYPE;
	xCTIPTARJ	T8000100.CTIPTARJ%TYPE;
	xCNUMSUCU	T8000100.CNUMSUCU%TYPE;
	xCTARJETA	T8000100.CTARJETA%TYPE;
	xCNUMREFE	T8000100.CNUMREFE%TYPE;
	xCTERMFIS	T8000100.CTERMFIS%TYPE;
	xCTERMINL	T8000100.CTERMINL%TYPE;
	xCTIPOPER	T8000100.CTIPOPER%TYPE;
	xCNUMPLAN	T8000100.CNUMPLAN%TYPE;
	xNIMPORTE	T8000100.NIMPORTE%TYPE;
	xCFECHOPE	T8000100.CFECHOPE%TYPE;
	xCHORAOPE	T8000100.CHORAOPE%TYPE;
	xFECHARTA	T8000100.FECHARTA%TYPE;
	xCOESTADO	T8000100.COESTADO%TYPE;
	xCEMPLEAD	T8000100.CEMPLEAD%TYPE;
	xCNUCLAVE	T8000100.CNUCLAVE%TYPE;
	xCTELEFON	T8000100.CTELEFON%TYPE;
	xNVERSION	VARCHAR(16);
	xCONTADOR	NUMBER(8);
	xNERRORES	NUMBER(8);

    /* Define cursor (manejo implicito: no se abre, lee, ni cierra) */
	CURSOR curPIM IS
		SELECT  CEMPRESA, CTRANSAC, CDOCUMEN, CTIPTARJ,
		        CNUMSUCU, CTARJETA, CNUMREFE, CTERMFIS,
		        CTERMINL, CTIPOPER, CNUMPLAN, NIMPORTE, CFECHOPE,
		        CHORAOPE, FECHARTA, COESTADO, CEMPLEAD, CNUCLAVE,
		        CTELEFON, FPROCESA
		FROM T8000100
		WHERE FPROCESA IS NULL AND COESTADO = '02'
		ORDER BY CNUCLAVE
		FOR UPDATE OF FPROCESA;

BEGIN

	xNVERSION := 'v1.03 17-Ene-18';
	DBMS_OUTPUT.PUT_LINE(xNVERSION);
	DBMS_OUTPUT.PUT_LINE('COMIENZO ' || 
	                     TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));

	/* Inicia contadores */
	xCONTADOR:=0;
	xNERRORES:=0;

	/* Define registro sobre cursor */
	FOR recPIM IN curPIM

	/* Recorre el cursor */
	LOOP
		
		/* Asigna variables de registro a variables locales */
		xCTRANSAC := recPIM.CTRANSAC;
		xCDOCUMEN := recPIM.CDOCUMEN;
		xCTIPTARJ := recPIM.CTIPTARJ;
		xCNUMSUCU := recPIM.CNUMSUCU;
		xCTARJETA := recPIM.CTARJETA;
		xCNUMREFE := recPIM.CNUMREFE;
		xCTERMFIS := recPIM.CTERMFIS;
		xCTERMINL := recPIM.CTERMINL;
		xCTIPOPER := recPIM.CTIPOPER;
		xCNUMPLAN := recPIM.CNUMPLAN;
		xNIMPORTE := recPIM.NIMPORTE;
		xCFECHOPE := recPIM.CFECHOPE;
		xCHORAOPE := recPIM.CHORAOPE;
		xFECHARTA := recPIM.FECHARTA;
		xCOESTADO := recPIM.COESTADO;
		xCEMPLEAD := recPIM.CEMPLEAD;
		xCNUCLAVE := recPIM.CNUCLAVE;
		xCTELEFON := recPIM.CTELEFON;
					
		BEGIN

			xCONTADOR := xCONTADOR + 1;

			/* Realiza el INSERT en la tabla */
			INSERT INTO TI_HA 
				(ID              , EMPRESA       , T_REMOTA      ,
				 T_PRESENTACION  , EMISOR        , NRO_COMERCIO  ,
				 NRO_TARJETA     , NRO_TICKET    , COD_AUTORIZA  ,
				 NRO_CAJA        , NRO_LOTE      , NRO_TERMINAL  ,
				 OPERACION       , NPLAN         , IMPORTE       ,
				 MONEDA          , F_TRANSACCION , H_TRANSACCION ,
				 F_PRESENTACION                                  ,
				 H_PRESENTACION                                  ,
				 FORMA_VTA       , TIPO_TARJETA  , TIPO_CAPTURA  ,
				 TIPO_CUPON      , LECTURA_BANDA , RESPUESTA     ,
				 OPERADOR        , CUSTOM1       , CUSTOM2       ,
				 IDCOEFICIENTE                                   ,
				 ARCHIVO_ORIGEN                                  ,
				 F_PROCESO                                       ,
				 H_PROCESO                                       ,
				 COD_ERROR       , ID_TRAN_LINK                  ,
				 LEG_EMPLEADO    , BANCO         , TERM_POS      ,
				 CUPON_POS         )
			VALUES  
				(S_TI_HA.NEXTVAL , 'COTO'        , xCNUMSUCU     ,
				 xCDOCUMEN       , xCTIPTARJ     , xCNUMSUCU     ,
				 xCTARJETA       , xCTRANSAC     , xCNUMREFE     ,
				 xCTERMFIS       , '054'         , xCTERMINL     ,
				 '20'            , xCNUMPLAN     , xNIMPORTE     ,
				 'P'             , xCFECHOPE     , xCHORAOPE     ,
				 TO_CHAR(xFECHARTA, 'YYYYMMDD')                  ,
				 TO_CHAR(xFECHARTA, 'HH24MISS')                  ,
				 ' '             , ' '           , ' '           ,
				 ' '             , 'N'           , xCOESTADO     ,
				 xCEMPLEAD       , xCNUCLAVE     , xCTELEFON     ,
				 NULL                                            ,
				 'INTERFACE_PIM_SIT'                             ,
				 TO_CHAR(SYSDATE, 'YYYYMMDD')                    ,
				 TO_CHAR(SYSDATE, 'HH24MISS')                    ,
				 NULL            , NULL                          ,
				 NULL            , NULL          , NULL          ,
				 NULL              );
		
			/* Actualiza registro procesado */
			UPDATE T8000100
			SET FPROCESA = SYSDATE
			WHERE CURRENT OF curPIM;

			DBMS_OUTPUT.PUT_LINE('REG.'||xCONTADOR||':'||xCNUCLAVE||' OK');
			
			/* Maneja errores */
			EXCEPTION
			WHEN OTHERS THEN
			xNERRORES := xNERRORES + 1;
			DBMS_OUTPUT.PUT_LINE('REG.'||xCONTADOR||':'
			                           ||xCNUCLAVE||' ERROR:'||SQLCODE);
		END;

	END LOOP;

	/* Confirma movimientos */
	COMMIT;
	DBMS_OUTPUT.PUT_LINE( 'REGISTROS PROCESADOS:'||xCONTADOR
	                                ||' ERRORES:'||xNERRORES);

	/* Sale por errores no manejados */
	EXCEPTION
	WHEN OTHERS THEN
	xNERRORES := xNERRORES + 1;
	DBMS_OUTPUT.PUT_LINE('REGISTRO:'||xCNUCLAVE||' ERROR:'||SQLCODE);
END;

/

spool off
quit
