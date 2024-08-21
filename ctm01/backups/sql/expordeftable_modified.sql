set heading off
set echo off
set termout off
set feedback off
set serveroutput off
set verify off
set pagesize 0
set linesize 100
set autoprint off
spool &1
select DATA_CENTER,SCHED_TABLE,LAST_UPLOAD from EMUSER.DEF_VER_TABLES WHERE TRUNC(LAST_UPLOAD) = TRUNC(sysdate) ORDER BY DATA_CENTER;
spool off
exit
