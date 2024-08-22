set serveroutput on
set echo off
set verify off
set feedback off
spool &1
DECLARE
begin
    
    PTES0330;
	PTES0340;
	PTES0370;

end;
/
spool off
quit