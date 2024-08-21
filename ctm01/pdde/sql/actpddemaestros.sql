set serveroutput on
set echo off
set verify off
set feedback off

spool &1

DECLARE
  POBSERVACIONES VARCHAR2(200);
  v_Return NUMBER;
BEGIN
    v_Return := PDE_ABM_MAESTROS.PRINCIPAL(
    POBSERVACIONES => POBSERVACIONES
    );
    DBMS_OUTPUT.PUT_LINE('v_Return = ' || v_Return);
END;
/
spool off
quit
