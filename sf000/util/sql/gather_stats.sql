alter session set"_complex_view_merging"=false;
set heading off 
set echo off
set termout on
set serveroutput on
set verify on
set pagesize 0 
spool &2
BEGIN
   DBMS_STATS.gather_schema_stats (ownname               => '&1',
                                   estimate_percent      => 15,
                                   method_opt            => 'for all indexed columns',
                                   CASCADE               => TRUE,
                                   DEGREE                => 20
                                  );
END;
/
spool off
exit
