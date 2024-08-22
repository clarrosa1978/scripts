set heading off 
set echo off
set termout on
set serveroutput on
set verify on
set pagesize 0 
spool &3
DECLARE
   v_cantidad   NUMBER DEFAULT 0;
BEGIN
   FOR i IN (SELECT c.idcompag,
                    (SELECT nomvalor
                       FROM cdigi.rcparametros@sf000_sf&2
                      WHERE idnombre = 'SUCURSAL') sucursal, c.idcotipo,
                    t.desctipo, t.desccorta, c.impocomp, c.idmovsts,
                    c.feinsert, c.idpedido, c.feccompr, c.comprnro,
                    c.termintk, c.transatk, p.nrotarje, p.entidadt,
                    p.idbancoe, p.bancoemi, p.codautor, p.comercio,
                    p.termipos, p.transpos, p.idtarjol, p.lugarcob,
                    p.nucuotas, p.formatoc, '0'xprocesa, '0'
               FROM cdigi.rccomprobantes@sf000_sf&2 c,
                    cdigi.rccomprobantestipos@sf000_sf&2 t,
                    cdigi.rccupones@sf000_sf&2 p
              WHERE c.idcotipo = t.idcotipo
                AND c.idcompag = p.idcompag(+)
                AND c.feccompr = TO_CHAR(TO_DATE(&1, 'YYYYMMDD') - 1, 'YYYYMMDD')
                AND c.idmovsts > 0)
   LOOP
      INSERT INTO cdigi.cdigimovs
           VALUES (i.idcompag, i.sucursal, i.idcotipo, i.desctipo,
                   i.desccorta, i.impocomp, i.idmovsts, i.feinsert,
                   i.idpedido, i.feccompr, i.comprnro, i.termintk,
                   i.transatk, i.nrotarje, i.entidadt, i.idbancoe,
                   i.bancoemi, i.codautor, i.comercio, i.termipos,
                   i.transpos, i.idtarjol, i.lugarcob, i.nucuotas,
                   i.formatoc, '0', 0);

      v_cantidad := v_cantidad + 1;

      IF v_cantidad > 1
      THEN
         COMMIT;
         v_cantidad := 0;
      END IF;
   END LOOP;

   COMMIT;
END;
/
spool off
UPDATE cdigimovs SET ID_MEDIODEPAGO='100'
WHERE ID_MEDIODEPAGO='0' AND  IDCOTIPO IN ('4')
/
COMMIT
/
UPDATE cdigi.cdigimovs SET ID_MEDIODEPAGO =
CASE 
       WHEN (UPPER(ENTIDADT))  LIKE '%EXPRE%'          THEN '517'
       WHEN (UPPER(ENTIDADT))  LIKE '%SHOPPING%'       THEN '512'
       WHEN (UPPER(ENTIDADT))  LIKE '%DINERS%'         THEN '509'
       WHEN (UPPER(ENTIDADT))  LIKE '%ITALCRED%'       THEN '519'
       WHEN (UPPER(ENTIDADT))  LIKE '%CABAL%'          THEN '504'
       WHEN (UPPER(ENTIDADT))  LIKE '%NARAN%'          THEN '503'
       WHEN (UPPER(ENTIDADT))  LIKE '%MASTER%'         THEN '501'
       WHEN (UPPER(ENTIDADT))  LIKE '%VISA%'           THEN '502'
       WHEN (UPPER(ENTIDADT))  LIKE '%NATIVA%'         THEN '515'
       WHEN (UPPER(ENTIDADT))  LIKE '%SUPERCARD%'      THEN '567'
       WHEN (UPPER(ENTIDADT))  LIKE '%TCI%'            THEN '530'
       WHEN (UPPER(ENTIDADT))  LIKE '%ARGENCARD%'      THEN '505'
       WHEN (UPPER(ENTIDADT))  LIKE '%KADICARD%'       THEN '525'
       WHEN (UPPER(ENTIDADT))  LIKE '%AUTOMATICA%'     THEN '521'
       WHEN (UPPER(ENTIDADT))  LIKE '%CREDENCIAL%'     THEN '518'
       WHEN (UPPER(ENTIDADT))  LIKE '%FRANCA%'         THEN '510'
       WHEN (UPPER(ENTIDADT))  LIKE '%AMEX%'           THEN '517'
       WHEN (UPPER(ENTIDADT))  LIKE '%PROPIA%'         THEN '511'
END 
WHERE ID_MEDIODEPAGO='0' AND IDCOTIPO IN ('9','2')
/
COMMIT
/
UPDATE cdigimovs SET ID_MEDIODEPAGO =
CASE 
       WHEN (UPPER(ENTIDADT))  LIKE '%VISA%'            THEN '508'
       WHEN (UPPER(ENTIDADT))  LIKE '%CABAL%'           THEN '524'
       WHEN (UPPER(ENTIDADT))  LIKE '%SHOPPING%'        THEN '522'
       WHEN (UPPER(ENTIDADT))  LIKE '%MAESTRO%'         THEN '506'
       WHEN (UPPER(ENTIDADT))  LIKE '%ARGENTA%'         THEN '564'
       WHEN (UPPER(ENTIDADT))  LIKE '%MASTER%'          THEN '539'
       WHEN (UPPER(ENTIDADT))  LIKE '%DINERS%'          THEN '509'
       WHEN (UPPER(ENTIDADT))  LIKE '%FRANCA%'          THEN '530'
END 
WHERE ID_MEDIODEPAGO='0' AND IDCOTIPO IN ('3','10')
/
COMMIT
/
exit
