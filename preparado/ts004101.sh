#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: PREPARADO-ZE                                           #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Levantar el proceso director.                          #
# Nombre del programa: ts004101.sh                                            #
# Nombre del JOB.....: TS004101                                               #
# Descripcion........: Ejecuta el programa ts004101.                          #
# Modificacion.......: 04/04/2006                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="ts004101"
export PARAMETRO="BACKGRND"
export PATHAPL="/tecnol/preparado"
export PATHLOG="${PATHAPL}/log"
export PATHPRG="/sfctrl/sfgv/bin"
export PROGRAMA="${PATHPRG}/${NOMBRE}"
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
if [ -x ${PROGRAMA} ]
then
	if [ `ps -ef | grep "${NOMBRE} ${PARAMETRO}" | grep -v grep | wc -l` -lt 1 ]
	then
		${PROGRAMA} ${PARAMETRO} &
		if [ $? != 0 ]
		then
			Enviar_A_Log "ERROR - Error durante la ejecucion ${PROGRAMA}." ${LOGSCRIPT}
               		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
       			exit 7
		else
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
			sleep 60
               		exit 0
		fi
	fi
else
       	Enviar_A_Log "ERROR - No hay permisos de ejecucion para ${PROGRAMA}." ${LOGSCRIPT}
       	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
       	exit 88
fi
