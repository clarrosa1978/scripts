/* ************************************************************************
   Nombre:  GPA.CosteaMovimientoGPA
   Autor:   Laura Fortunelli
   Fecha:  04/11/2019
   DESCRIPCION : Costea los movimientos de Stock que estan nulos

   ************************************************************************/
set serveroutput on
set echo off
set verify off
set feedback off

spool &1

declare
Begin
GPA.CosteaMovimientoGPA;
end;
/

spool off
quit
