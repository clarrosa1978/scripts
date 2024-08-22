#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PRECIOS-GDM-ZE000                                      #
# Grupo..............: GENERACION                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Comprime los archivos de precios generados para poder  #
#                      transmitirlos a las sucursales.                        #
# Nombre del programa: comprimirprecios.sh                                    #
# Nombre del JOB.....: COMPPREC                                               #
# Descripcion........:                                                        #
# Modificacion.......: 03/07/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="comprimirprecios"
export PATHAPL="/tecnol/precios"
export PATHLOG="${PATHAPL}/log"
export PATHPRE="/sfctrl/data/descarga"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export ARCHIVOPREC="GM03???_??????????????_B"
#export ARCHIVOS="`ls -1 ${PATHPRE}/GM03???_*_B` 2>&1 >/dev/null"
export ARCHIVOS="`ls -1 ${PATHPRE}/${ARCHIVOPREC}`"

###############################################################################
###                            Funciones                                    ###
###############################################################################

autoload Enviar_A_Log
autoload Borrar
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ "${ARCHIVOS}" ]
then
	for I in ${ARCHIVOS}
	do
		compress -f ${I}
        	if [ $? != 0 ]
        	then
        		Enviar_A_Log "ERROR - Fallo la compresion del archivo ${I}." ${LOGSCRIPT}
                	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                	exit 13
        	fi
	done
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +3 -exec rm {} \;
	find ${PATHPRE} -name "${ARCHIVOPREC}.Z" -mtime +20 -exec rm {} \;
        exit 0
else
	Enviar_A_Log "AVISO - No se generaron novedades de precios." ${LOGSCRIPT}
       	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
        find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +3 -exec rm {} \;
        exit 0
fi
