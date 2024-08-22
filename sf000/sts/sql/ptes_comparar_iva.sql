set serveroutput on
set echo off
set verify off
set feedback off
spool &1
DECLARE
begin
    
    PKG_TES_IVA_Articulos.Recuperar_IVA;
	PKG_TES_IVA_Articulos.Comparar_IVA;
	
end;
/
spool off
quit
