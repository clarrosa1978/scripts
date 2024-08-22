#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTILIDADES                                             #
# Grupo..............: DATABASE                                               #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........:                                                        #
# Nombre del programa: depuratrc.sh                                           #
# Nombre del JOB.....: DEPURATRC                                              #
# Solicitado por.....:                                                        #
# Descripcion........: Depura fs del motor de la base de datos                #
# Solicitado por.....: Administracion DB                                      #
# Creacion...........: 27/05/2009                                             #
# Modificacion.......: 27/05/2009                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export PATHAPL="/u0110/app/oracle10/admin"
#export ARCHALERT="`find ${PATHAPL} -name 'alert*.log'"
export ORACLE_HOME="/u0110/app/oracle10/product/10.2.0"

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1
find ${PATHAPL} -name "*.trc" -mtime +3 -exec rm {} \;
find ${PATHAPL} -name "core_*" -mtime +3 -exec rm -r {} \;
find ${ORACLE_HOME}/rdbms/audit -name "*.aud" -mtime +30 -exec rm {} \;

#for LOG in ${ARCHALERT}
#do
#        mv ${LOG} ${LOG}.${FECHA}
#        [ $? != 0 ] && exit 58
#        compress ${LOG}.${FECHA}
#        [ $? != 0 ] && exit 13
#done
#find ${PATHAPL} -name "alert_*.Z" -mtime +15 -exec rm {} \;
exit 0
