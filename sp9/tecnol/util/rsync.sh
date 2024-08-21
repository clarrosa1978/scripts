#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: UNIX                                                   #
# Autor..............: Hugo Messina                                           #
# Objetivo...........: Sincronizar directorios con rsync.                     #
# Nombre del programa: rsync.sh                                               #
# Nombre del JOB.....: RSYNCSP9XXXXX                                          #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Creacion...........: 27/06/2017                                             #
# Modificacion.......:                                                        #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=`date +%Y%m%d`
export DIRORI=${1}
export DIRDES=${2}
export DELETE=${3}
export SERVDES=${4}
export NOMBRE="rsync"
export COMANDO=""

###############################################################################
###                            Funciones                                    ###
###############################################################################


###############################################################################
###                            Principal                                    ###
###############################################################################

if [ -x /usr/bin/rsync ]
then
	if [ "${SERVDES}" ]
	then
		if [ "${DELETE}" ] && [ "${DELETE}" = 'y' ]
		then
			COMANDO="rsync -a -v --delete ${DIRORI} ${SERVDES}:${DIRDES}"
		else
			COMANDO="rsync -a -v ${DIRORI} ${SERVDES}:${DIRDES}"
		fi
	else
		if [ "${DELETE}" ] && [ "${DELETE}" = 'y' ]
		then
			COMANDO="rsync -a -v --delete ${DIRORI} ${DIRDES}"
		else
			COMANDO="rsync -a -v ${DIRORI} ${DIRDES}"
		fi
	fi
	${COMANDO}
	STATUS=$?
	if [ $STATUS != 0 ] && [ $STATUS != 25 ] && [ $STATUS != 24 ]
	then
    		echo "Error al sincronizar fs al servidor ${SERVDES}"
    		exit 1
	fi
else
	echo "Error - No hay permisos de ejecucion para el comando /usr/bin/rsync"
	exit 1

fi
