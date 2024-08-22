ding off 
set echo off
set termout on
set serveroutput on
set verify on
set pagesize 0 
spool &1
BEGIN
DELETE u601.T6741400 WHERE ccoddesc = '1079';
DELETE u601.T6741400 WHERE ccoddesc = '6079';
COMMIT;
END;
/
EXIT;
spool off
