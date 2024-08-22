/*#############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: APERTURA-ZE000                                         #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Actualiza el campo XRCTORCP de la tabla T6040800.      #
# Nombre del programa: upd_t6040800.sql                                       #
# Nombre del JOB.....: T6040800                                               #
# Descripcion........: Modifica el campo XRCTORCP de la tabla T6040800.	      #
# Modificacion.......: 11/04/2006                                             #
#############################################################################*/
spool &1
update t6040800 set FRCTPROC=to_char(sysdate,'YYYYMMDD'),XRCTORCP='1',NLOGPROC=&2;
commit;
spool off
quit
