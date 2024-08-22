SET HEAD OFF
SET PAGES 0
SET FEED OFF
spool &1

SELECT max (noffsetl)
FROM t5450700
WHERE frctproc = (select trunc(to_date(fprocier,'DDMMYYYY')) from t6022600);
exit;
spool off
quit
