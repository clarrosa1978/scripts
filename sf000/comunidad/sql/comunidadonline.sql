SET SERVEROUTPUT ON 
SET VERIFY OFF
SET TERMOUT ON
SET FEED OFF


spool &1

DECLARE
vretorno NUMBER;
vsalida VARCHAR2(2000);
BEGIN
  dbms_output.put_line('Fecha = '||TO_CHAR(sysdate,'dd/mm/yyyy'));
  dbms_output.put_line('Hora Inicio = '||TO_CHAR(sysdate,'hh24:mi:ss'));
  
  CC_CONSULTAS.PROCESAR_ONLINE(vretorno, vsalida);

  dbms_output.put_line(SubStr('vretorno = '||TO_CHAR(vretorno), 1, 255));
  dbms_output.put_line(SubStr('vsalida = '||vsalida,1,255));
  dbms_output.put_line('Hora Fin = '||TO_CHAR(sysdate,'hh24:mi:ss'));
END;
/

spool off
quit
