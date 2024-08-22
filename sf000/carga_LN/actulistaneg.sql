set echo off
set timing on
set serveroutput on


spool /sfctrl/tmp/actulistaneg.log

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

    TRUNCAR_T6197500_ERR;

    open cur_listanegra;
                                                          
    loop
            fetch cur_listanegra into xctarjeta, xcsitcred;
            exit when cur_listanegra%notfound;

            totregist := totregist + 1;

            xhayerror := 0;

            if xcsitcred = 'B' then
                begin                       
                          DELETE T6197500
                          WHERE CTARJETA = xctarjeta;
                          
                          EXCEPTION
                          WHEN OTHERS THEN
                                  xhayerror := 1;                          
                                  canterror := canterror + 1;
                end;
            elsif xcsitcred = 'A' then
                begin
                          INSERT INTO T6197500
                          VALUES (xctarjeta, xcsitcred);   

                          EXCEPTION
                              WHEN OTHERS THEN
                                  xhayerror := 1;                          
                                  canterror := canterror + 1;
                end;
            else
                          canterror := canterror + 1;
                          xhayerror := 1;
            end if;   

            if xhayerror = 1 then
                          INSERT INTO T6197500_ERR
                          VALUES (xctarjeta, xcsitcred);                 
            end if;

            registros := registros + 1;

            if (registros >= 3000) then
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


