/*#############################################################################
# Aplicacion.........: MAYORISTA                                              #
# Grupo..............: INDICADORES                                            #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........:                                                        #
# Nombre del programa: indma01.sql                                            #
# Nombre del JOB.....: INDMA01                                                #
# Descripcion........: Genera el Indicador MA_01 en la tabla indicadores_01   #
#                      de la base de datos IGI.                               #
# Soliitado por......: Sergio Berteloot                                       #
# Creado.............: 15/01/2008                                             #
# Modificacion.......: 15/01/2008                                             #
#############################################################################*/
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
  INDICADOR_MA_01(vretorno,vsalida);
  dbms_output.put_line(SubStr('vretorno = '||TO_CHAR(vretorno), 1, 255));
  dbms_output.put_line(SubStr('vsalida = '||vsalida,1,255));
  dbms_output.put_line('Hora Fin = '||TO_CHAR(sysdate,'hh24:mi:ss'));
END;
/

spool off
quit
