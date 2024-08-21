#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: CTM                                                    #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realiza un exportdeftable de todas las tablas.         #
# Nombre del programa: expordeftable_all.sh                                   #
# Nombre del JOB.....: EXPDEFTABLEALL                                         #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Creacion...........: 09/09/2016                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="expordeftable_all"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export PATHEXP="/export"
export EXP="${PATHEXP}/${NOMBRE}.${FECHA}.xml"
export PF="${PATHAPL}/.ecs.pwd"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion del ${NOMBRE}." ${LOGSCRIPT}
if [ -x /home/ecs/bin/exportdeftable ]
then
	Enviar_A_Log "EJECUCION - Realizando export de todas las tablas." ${LOGSCRIPT}
	/home/ecs/bin/exportdeftable -pf ${PF} -s EM02 -arg ${PATHAPL}/${NOMBRE}.arg -out ${EXP}
	if [ $? = 0 ]
	then
		if [ -s ${EXP} ]
		then
			gzip -f ${EXP}
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
			find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
			exit 0
		else
                	Enviar_A_Log "ERROR - Error al generar export de todas las tablas." ${LOGSCRIPT}
                	Enviar_A_Log "FINALIZACION - Con ERRORES." ${LOGSCRIPT}
			exit 1
		fi
	else
		Enviar_A_Log "ERROR - Error al generar export de todas las tablas." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - Con ERRORES." ${LOGSCRIPT}
		exit 1
	fi
else
	Enviar_A_Log "ERROR - Sin permisos de ejecucion /home/ecs/bin/exportdeftable." ${LOGSCRIPT}   
	Enviar_A_Log "FINALIZACION - Con ERRORES." ${LOGSCRIPT}
	exit 88
fi
