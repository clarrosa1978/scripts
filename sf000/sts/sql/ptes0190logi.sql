SET SERVEROUTPUT ON 
SET VERIFY OFF
SET TERMOUT ON
SET FEED OFF

spool &1
DECLARE
v_salida NUMBER;
v_salidatxt VARCHAR2 (2000);
a number(5):=0;
b varchar2(255):='';
begin
dbms_output.enable (999999999999);
dbms_output.put_line ('Hora de Comienzo: ' || to_char (sysdate,'DD/MM/YYYY') || ' ' || to_char (sysdate, 'HH24:MI:SS'));
stscd.PTES0190 ('01','LOG',a,b);
dbms_output.put_line (v_salida || ' '|| v_salidatxt);
dbms_output.put_line ('Hora de Fin: ' || to_char (sysdate,'DD/MM/YYYY') || ' ' || to_char (sysdate, 'HH24:MI:SS'));
END;
/
spool off
quit