/*#############################################################################
# Aplicacion.........: PRECIOS-GDM-ZE000                                      #
# Grupo..............: GENERACION                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Obtiene el parametro datehora para la ejecucion del    #
#                      programa intgdmsf.                                     #
# Nombre del programa: obtdatehora.sql                                        #
# Nombre del JOB.....: DATEHORA                                               #
# Descripcion........:                                                        #
# Modificacion.......: 22/06/2006                                             #
#############################################################################*/
set head off
set feed off
set pagesize 0
spool &1
select MAX (TO_CHAR (DATEHORA)) from T9694500 where XCOMUPLU=1 ;
spool off
quit
