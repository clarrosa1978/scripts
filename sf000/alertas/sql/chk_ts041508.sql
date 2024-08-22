set serveroutput on
set termout off
set feedback off
set verify off
set echo off
set flush on
set time off
set timing off
set tab on
set trimout on
set sqlblanklines on
set pagesize 0

whenever sqlerror exit failure;

set termout on

declare

         cantidad       number; 

         err_code       number;
         err_msg        varchar2(255);
         fechaProceso   date := to_date('&1','DDMMYYYY');

begin

    begin

        select
               max(noffsetl)
               into cantidad 
               from u601.T7750700
               where frctproc=fechaProceso;

    exception
    
        when no_data_found then
    
            cantidad := 0;
    
        when others then
    
            err_code := sqlcode;
            err_msg  := sqlerrm;
    
            raise_application_error ( -20001,'ERROR: '||to_char(err_code,'999999')||'-'||substr(err_msg,1,60 ));
    
    end;

    dbms_output.put_line(to_char(cantidad,'99999999999999990'));

end;
/

quit
