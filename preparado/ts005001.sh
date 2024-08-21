#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: PREPARADO-ZE                                           #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecuta el preparado y activado de SF.                 #
# Nombre del programa: ts005001.sh                                            #
# Nombre del JOB.....: TS005001                                               #
# Descripcion........:                                                        #
# Modificacion.......: 04/04/2006                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="ts005001"
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
	${PROGRAMA}
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - Error durante la ejecucion ${PROGRAMA}." ${LOGSCRIPT}
               	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
       		exit 7
	else
		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
               	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
               	exit 0
	fi
else
       	Enviar_A_Log "ERROR - No hay permisos de ejecucion para ${PROGRAMA}." ${LOGSCRIPT}
       	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
       	exit 88
fi
