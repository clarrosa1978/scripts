#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Chequea la existencia de un archivo.                   #
# Nombre del programa: chk_file.sh                                            #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 28/06/2006                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export PATHARCHIVO=${2}
export ARCHIVO=${3}
export NOMBRE="chk_file.${ARCHIVO}"
export PATHAPL="/tecnol/tickets"
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

Check_Par 3 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -f ${PATHARCHIVO}/${ARCHIVO} ]
then
	if [ -s ${PATHARCHIVO}/${ARCHIVO} ]
	then
		Enviar_A_Log "AVISO - El archivo ${PATHARCHIVO}/${ARCHIVO} existe." ${LOGSCRIPT}
		chmod 444 ${PATHARCHIVO}/${ARCHIVO}
		if [ $? = 0 ]
		then
			Enviar_A_Log "AVISO - Cambiando permisos a el archivo ${PATHARCHIVO}/${ARCHIVO}." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
		 	find  ${PATHLOG} -name "${NOMBRE}*.log" -mtime +7 -exec rm {} \;
			exit 0
		else
			Enviar_A_Log "ERROR - No se pudo cambiar los permisos del archivo ${PATHARCHIVO}/${ARCHIVO}." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
			exit 57
		fi
	else
		Enviar_A_Log "ERROR - El archivo ${PATHARCHIVO}/${ARCHIVO} tiene tama�o 0." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	 	exit 11
	fi
else
	Enviar_A_Log "ERROR - El archivo ${PATHARCHIVO}/${ARCHIVO} no existe." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 12
fi
