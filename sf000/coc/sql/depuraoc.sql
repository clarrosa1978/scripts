/* ************************************************************************
   Nombre:  DEPURA_OC
   Autor:   SMRODRIGUEZ
   Fecha:   20/09/2021
   Descripcion: Depura las OC del sistema COC, en SFC
************************************************************************/

set serveroutput on
set echo off
set verify off
set feedback off
spool &1

BEGIN
 PR_DEPURA  ;
END;
/
spool off
