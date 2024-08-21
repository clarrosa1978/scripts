/* ************************************************************************
   Nombre:  PizarraIncubacion
   Autor:   Laura Fortunelli
   Fecha:   02/06/2021
   Descripcion: GPA_INCUBACION.OBTENCION_DATOS_INCUBACION;
   Mata sesiones  
   Parametros:  
   ************************************************************************/

set serveroutput on
set echo off
set verify off
set feedback off

spool &1
 

declare


/* ********************************************************
   PROCEDIMIENTOS
   ****************************************************** */
Begin
dbms_output.enable(999999);
dbms_output.Put_Line('INICIO:'||to_char(sysdate,'DD/MM/YYYY HH24:mi:ss'));
GPA_INCUBACION.OBTENCION_DATOS_INCUBACION;
dbms_output.Put_Line('FIN:'||to_char(sysdate,'DD/MM/YYYY HH24:mi:ss'));
end;
/
spool off
quit
