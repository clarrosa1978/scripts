set heading off 
set echo off
set termout on
set serveroutput on
set verify on
set pagesize 0 
spool &2
BEGIN
   DBMS_STATS.gather_schema_stats (ownname               => '&1',
                                   estimate_percent      => 30,
                                   method_opt            => 'for all indexed columns',
                                   CASCADE               => TRUE,
                                   DEGREE                => 10
                                  );
END;
/
spool off
exit
