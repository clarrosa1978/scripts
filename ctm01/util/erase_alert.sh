#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: CTM                                                    #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Depura las alertas de la ECS.                          #
# Nombre del programa: erase_alert.sh                                         #
# Nombre del JOB.....: ERASEALERT                                             #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Creacion...........: 12/11/2009                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export DIA=${2}
export NOMBRE="erase_alert"
export PATHAPL="/tecnol/util"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion del ${NOMBRE}." ${LOGSCRIPT}
if [ -x /home/ecs/bin/erase_alerts ]
then
	Enviar_A_Log "EJECUCION - Eliminando alertas anteriores a ${DIA}." ${LOGSCRIPT}
	/home/ecs/bin/erase_alerts -U emuser -P password -D ${DIA} -F
	if [ $? = 0 ]
	then
		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
		find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
		exit 0
	else
		Enviar_A_Log "ERROR - Error al depurar alertas." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - Con ERRORES." ${LOGSCRIPT}
		exit 1
	fi
else
	Enviar_A_Log "ERROR - Sin permisos de ejecucion /home/ecs/scripts/erase_alerts." ${LOGSCRIPT}   
	Enviar_A_Log "FINALIZACION - Con ERRORES." ${LOGSCRIPT}
	exit 88
fi
