SET SERVEROUTPUT ON
SET VERIFY OFF
SET TERMOUT ON
SET FEED OFF
col name for a40
col value for a20
set lines 180
SET HEAD OFF
alter system set log_archive_dest_state_2=defer SCOPE=both;
select name,value from v$parameter where name like 'log_archive_dest_state_2%';
quit;
