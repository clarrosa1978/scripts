set serveroutput on
set echo off
set verify off
set feedback off
spool &1
DECLARE
begin
    
    PTES_Informa_CierreOperativo;

end;
/
spool off
quit
