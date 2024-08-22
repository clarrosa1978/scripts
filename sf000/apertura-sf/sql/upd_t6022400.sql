/*#############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: APERTURA-ZE000                                         #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Finalizar la apertura de empresa 01 de SF.             #
# Nombre del programa: upd_t6022400.sql                                       #
# Nombre del JOB.....: T6022400                                               #
# Descripcion........: Modifica el campo XSITCIER de la tabla T6022400.       #
# Modificacion.......: 11/04/20065                                            #
#############################################################################*/
spool &1
update t6022400 set FHPROCIE = TO_DATE( TO_CHAR( SYSDATE,'YYYYMMDD')||'000000','YYYYMMDDHH24MISS'),
XSITCIER='1' where CEMPRESA='01';
commit;
spool off
quit
