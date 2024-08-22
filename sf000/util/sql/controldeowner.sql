SET SERVEROUTPUT ON
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK ON
SET LINES 100
colum owner format a5
column index_name format a26
column table_owner format a5
column table_name format a20

SPOOL &1

SELECT 'DROP INDEX SYS.'||OBJECT_NAME|| ';' FROM DBA_OBJECTS WHERE OBJECT_NAME LIKE 'QUEST_SX_IDX%'     
/
SELECT OWNER, INDEX_NAME , TABLE_OWNER, TABLE_NAME  FROM DBA_INDEXES WHERE OWNER<>TABLE_OWNER
/

SPOOL OFF
quit;
exit

