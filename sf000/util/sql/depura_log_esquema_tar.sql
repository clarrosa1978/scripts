set serveroutput on
set termout on
set feedback off
set doc off
set verify off
set linesize 80
spool &1

BEGIN
DEPURACION_TAR;
END;
/
spool off
exit;
