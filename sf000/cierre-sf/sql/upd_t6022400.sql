/*#############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: CIERRE-ZE000                                           #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Finalizar el cierre de empresa 01 de SF.               #
# Nombre del programa: upd_t6022400.sql                                       #
# Nombre del JOB.....: T6022400                                               #
# Descripcion........: Modifica el campo XSITCIER de la tabla T6022400.       #
# Modificacion.......: 05/04/2006                                             #
#############################################################################*/
spool &1
update t6022400 set XSITCIER='2' where CEMPRESA='01';
commit;
spool off
quit
