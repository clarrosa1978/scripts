#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TARJETAS                                               #
# Grupo..............: CLUBNACION                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........:                                                        #
# Nombre del programa: busconacion.sh                                         #
# Nombre del JOB.....: BUSCONACION                                            #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 19/10/2011                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="busconacion"
export PATHAPL="/tarjetas/nacion"
export PATHLOG="${PATHAPL}/log"
export LISTANAC="${PATHALOG}/listanacion.txt"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LISTANAC}
/usr/bin/curl --disable-eprt -n -k --ftp-ssl ftp://ftps_nacion/credenciales/ >${LISTANAC}
if [ -s ${LISTANAC} ]
then
	
