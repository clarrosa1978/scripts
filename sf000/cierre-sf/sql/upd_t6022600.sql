/*#############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: CIERRE-ZE000                                           #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Finalizar el cierre del centro de SF.                  #
# Nombre del programa: upd_t6022600.sql                                       #
# Nombre del JOB.....: T6022600                                               #
# Descripcion........: Modifica el campo XSITCIER de la tabla T6022600.       #
# Modificacion.......: 05/04/2006                                             #
#############################################################################*/
spool &1
update t6022600 set XSITCIER='2';
commit;
spool off
quit
