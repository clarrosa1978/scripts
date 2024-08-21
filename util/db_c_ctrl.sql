SET SERVEROUTPUT ON 
SET VERIFY OFF
SET TERMOUT ON
SET FEED OFF

spool &1

alter system set log_archive_dest_state_2=defer SCOPE=both;
quit;
/

spool off
quit

