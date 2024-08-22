
SET SERVEROUTPUT ON

SET VERIFY OFF

SET TERMOUT ON

SET FEED OFF

 

spool &1

DECLARE

v_salida NUMBER;

v_salidatxt VARCHAR2 (2000);

BEGIN

dbms_output.enable (999999999999);

dbms_output.put_line ('Hora de Comienzo: ' || to_char (sysdate,'DD/MM/YYYY') || ' ' || to_char (sysdate, 'HH24:MI:SS'));

cancelacion_reserva;


dbms_output.put_line ('Hora de Fin: ' || to_char (sysdate,'DD/MM/YYYY') || ' ' || to_char (sysdate, 'HH24:MI:SS'));

END;

/

 

spool off

exit

 
