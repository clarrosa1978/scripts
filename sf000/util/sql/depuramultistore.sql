SET SERVEROUTPUT ON
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK ON
SET LINES 100

SPOOL &1

delete from t6170100 where substr(fctrentr,1,8) < to_char(sysdate-3,'YYYYMMDD')
/
commit
/
delete from t6170200 where substr(fmovcaja,1,8) < to_char(sysdate-3,'YYYYMMDD')
/
commit
/
delete from t6170400 where substr(FSOBENVI,1,8) < to_char(sysdate-3,'YYYYMMDD')
/
commit
/
delete from t6170800 where substr(FEJECARQ,1,8) < to_char(sysdate-3,'YYYYMMDD')
/
commit
/
delete from t6170900 where substr(FINTERVE,1,8) < to_char(sysdate-3,'YYYYMMDD')
/
commit
/
delete from t6171000 where substr(FEARQUEO,1,8) < to_char(sysdate-3,'YYYYMMDD')
/
commit
/
delete from t6171100 where substr(FMOVCAJA,1,8) < to_char(sysdate-3,'YYYYMMDD')
/
commit
/
delete from t6171200 where FANIOHIS||FPERINIC < to_char(sysdate-3,'YYYYMMDD')
/
commit
/


SPOOL OFF
EXIT

