/* ************************************************************************
   Nombre:  Pcontrolrecu
   Sistema: STS
   Autor:   SMRODRIGUEZ
   Fecha:   20/09/2021
   Descripcion: Informa novedades de control de recuento
************************************************************************/

set serveroutput on
set echo off
set verify off
set feedback off
spool &1
DECLARE
 
BEGIN
 PTES_ControlRecu  ;
END;
/
spool off


quit
