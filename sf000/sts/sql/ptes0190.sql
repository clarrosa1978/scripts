SET SERVEROUTPUT ON 
SET VERIFY OFF
SET TERMOUT ON
SET FEED OFF

spool &2
DECLARE

v_salida NUMBER;
v_salidatxt VARCHAR2 (2000);
v_suc varchar2(3);

BEGIN
v_suc := lpad(&1, 3, '0');

dbms_output.enable (999999999999);
dbms_output.put_line ('Hora de Comienzo: ' || to_char (sysdate,'DD/MM/YYYY') || ' ' || to_char (sysdate, 'HH24:MI:SS'));
sts_050_093.ptes0190 ('01', v_suc, v_salida, v_salidatxt);
dbms_output.put_line (v_salida || ' '|| v_salidatxt);
dbms_output.put_line ('Hora de Fin: ' || to_char (sysdate,'DD/MM/YYYY') || ' ' || to_char (sysdate, 'HH24:MI:SS'));

END;

/

spool off
quit
