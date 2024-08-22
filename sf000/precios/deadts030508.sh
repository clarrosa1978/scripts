#!/bin/ksh
###############################################################################
# Aplicacion.........: NTCIERRE-ZE                                            #
# Grupo..............: PRECADENA                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Mata los procesos del usuario que recibe como parametro#
# Nombre del programa: deadora.sh                                             #
# Nombre del JOB.....: DEADPROC                                               #
# Descripcion........:                                                        #
# Modificacion.......: 11/04/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export NOMBREUSU=${1}
export LISTPROC=""

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1
LISTPROC=`ps -ef|sed '1d'|grep ${NOMBREUSU} | grep -v grep | grep -v deadproc | awk ' ( $1 == "'${NOMBREUSU}'" ) { print $2 } ' | sort -r`
if [ "${LISTPROC}" ]
then
	for PID in ${LISTPROC}
	do
		kill -9 ${PID}
	done
	sleep 5
	LISTPROC=`ps -ef|sed '1d'|grep ${NOMBREUSU} | grep -v grep |awk ' ( $1 == "'${NOMBREUSU}'" ) { print $2 } ' | sort -r`
	if [ "${LISTPROC}" ]
	then
		exit 18	
	else
		exit 0
	fi
else
	exit 0
fi
