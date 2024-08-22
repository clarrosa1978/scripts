/*#############################################################################
# Aplicacion.........: STOREFOW-XXX (XXX=NUMERO DE SUC EN 3 DIGITOS)          #
# Grupo..............: CIERRE-XXX (XXX=NUMERO DE SUC EN 3 DIGITOS)            #
# Autor..............: TECNOLOGIA (C.A.S)                                     #
# Objetivo...........: Realizar el cierre de la sucursal                      #
# Nombre del programa: sfcierr070.sql                                         #
# Descripcion........: Chequea en la tabla t7740900 la cantidad de            #
#                      transacciones realizadas para la suc recibida como     #
#                      parametro                                              #
# Modificacion.......: 2003/09/12                                             #
#############################################################################*/

set head off
set verify off
spool $SFSW_TMP/sfcierr070.&&1..tmp 
select count(1) from t7740900 where cncentro = &&1;
spool off
quit
