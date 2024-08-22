SET SERVEROUTPUT ON
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK ON
SET LINES 100
colum pieza format a33
column etiqueta format a20
column start_time format a20
column completion_time format a20

SPOOL &1

select handle Pieza,TAG Etiqueta,START_TIME Inicio,Completion_time Fin , round(ELaPSED_SECONDS/60) "TIEMPO ''"  from GV$BACKUP_PIECE     
where trunc(completion_time) = trunc (sysdate-1)     
/

SPOOL OFF
quit;
exit

