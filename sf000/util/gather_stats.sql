set heading off 
set echo off
set termout on
set serveroutput on size 1000000 
set verify on
set pagesize 0 
spool &2
begin
for x in (select table_name from dba_tables where owner='&1')
loop
dbms_output.put_line('TABLE : ' || x.table_name);
begin
dbms_stats.gather_table_stats(
ownname => '&1',
tabname => x.table_name,
method_opt            => 'for all indexed columns',
cascade => TRUE, 
estimate_percent => 20,
DEGREE                => 20);
exception
when others then
dbms_output.put_line('### ERROR: ' || sqlerrm);
exit;
end;
end loop;
end;
/
spool off
exit

