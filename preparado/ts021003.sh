#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: PREPARADO-ZE                                           #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Ejecuta el director de roolo de control (ts021003.sh)  #
# Nombre del programa: ts021003.sh                                            #
# Nombre del JOB.....: TS021003                                               #
# Descripcion........:                                                        #
# Modificacion.......: 13/06/2006                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="ts021003"
export PATHAPL="/tecnol/preparado"
export PATHLOG="${PATHAPL}/log"
export PATHPRG="/sfctrl/sfgv/bin"
export PATHTLOG="/sfctrl/d"
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
PARAMETROS="`ls -1t ${PATHTLOG}/tlog??.dat | head -1 | cut -c11-20`"
if [ ${PARAMETROS} ]
then
	if [ -x ${PROGRAMA} ]
	then
		${PROGRAMA} ${PARAMETROS} &
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
	else
        	Enviar_A_Log "ERROR - No hay permisos de ejecucion para ${PROGRAMA}." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        	exit 88
	fi
else
	Enviar_A_Log "ERROR - No se pudo determinar el n° de tlog." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 4
fi
