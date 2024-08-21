#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: APERTURA-ZE                                            #
# Grupo..............: APERTURA-SF                                            #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Mata los procesos enviotlog y EnvioDom activos.        #
# Nombre del programa: killlog.sh                                             #
# Nombre del JOB.....: KILLLOG                                                #
# Descripcion........:                                                        #
# Modificacion.......: 27/03/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="killlog"
export PATHAPL="/tecnol/apertura-sf"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
export PID=`ps -fu sfctrl | egrep 'enviotlog|EnvioDom' | grep -v grep | awk ' { print $2 } '`
if [ ${PID} ]
then
	for i in ${PID}
	do
		kill -9 $i
		if [ $? != 0 ]
		then
			Enviar_A_Log "ERROR - No se pudo matar el proceso enviotlog ${i}." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 18
		fi
	done
fi

Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
exit 0
