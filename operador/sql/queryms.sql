SET SERVEROUTPUT OFF
	select substr(what,1,48) job, broken, last_date  from dba_jobs where what like '%job_node_check%' order by what;
/
exit;
