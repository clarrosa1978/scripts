set serveroutput on     
set echo off    
set verify on  
set feedback off       
spool &2        
DECLARE
    IDACTIVACION NUMBER;
    BEGIN
        IDACTIVACION := OLCV.SEQ_PROMO_ACTIVACION.NEXTVAL;
        INSERT INTO OLCV_LOG_PROMO_ACTIVACION (ID_ACTIVACION,FECHA_ACTIVACION,FINSERT) VALUES (IDACTIVACION,TO_DATE('&1','YYYY-MM-DD HH24:MI:SS'),SYSDATE);
        COMMIT;
    END;
/
spool off
quit
~
