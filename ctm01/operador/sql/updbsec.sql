SET SERVEROUTPUT ON
SET VERIFY OFF
SET TERMOUT ON
SET FEED OFF
col name for a40
col value for a20
set lines 180
SET HEAD on
shutdown abort; 
startup nomount;
alter database mount standby database;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
quit;
