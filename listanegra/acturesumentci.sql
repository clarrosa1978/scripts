set echo off
set timing on
set serveroutput on

exec TRUNCAR_T6197500_ERR


spool &1

declare
    xctarjeta    varchar2(20);
    xcsitcred    varchar2( 1); 
    xhayerror    varchar2( 1);
    registros    number(8);
    canterror    number(8);
    totregist    number(8);

        cursor cur_listanegra  is
                SELECT CTARJETA, CSITCRED
                FROM   T6197500_TEMP;
                      
BEGIN 
    
    registros := 0;
    canterror := 0;
    totregist := 0;

    open cur_listanegra;
                                                          
    loop
            fetch cur_listanegra into xctarjeta, xcsitcred;
            exit when cur_listanegra%notfound;

            totregist := totregist + 1;

            xhayerror := 0;
              begin
                          INSERT INTO U601.T6197500
                          VALUES (xctarjeta, '9'); 
                          EXCEPTION
                              WHEN DUP_VAL_ON_INDEX THEN
				 UPDATE T6197500 SET csitcred = '9' where ctarjeta = xctarjeta;
							  WHEN OTHERS THEN
                                  xhayerror := 1;                         
                                  canterror := canterror + 1;
                end;
            if xhayerror = 1 then
                          INSERT INTO T6197500_ERR
                          VALUES (xctarjeta, xcsitcred);                 
            end if;

            registros := registros + 1;

            if (registros >= 10000) then
                          COMMIT;
                          registros := 0;
            end if;
    end loop;

    COMMIT;
    
    close cur_listanegra;  
    
END;

/

spool off

quit;
