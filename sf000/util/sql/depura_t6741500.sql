set serveroutput on
set termout on
set feed on
set doc off
spool &3
exec u601.depurat6741500('&1', '&2')
spool off
exit