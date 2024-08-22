#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: CIERRE-ZE000                                           #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Resguardar y generar logs de la apertura y cierre.     #
# Nombre del programa: resguardar_lclog.sh                                    #
# Nombre del JOB.....: BKLCLOG                                                #
# Descripcion........: Resguarda el archivo /sfctrl/l/lclog y  genera uno     #
#                      nuevo para el inicio del dia.                          #
# Modificacion.......: 05/04/2006                                             #
###############################################################################
 
set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
 
export FECHA=${1}
export PROGRAMA="resguardar_lclog"
export PATHAPL="/sfctrl"
export NOMBRE="lclog"
export PATHLCLOG="${PATHAPL}/l"
export LCLOG="${PATHLCLOG}/${NOMBRE}"
export PATHLOG="/tecnol/cierre-sf/log"
export LOGSCRIPT="${PATHLOG}/${PROGRAMA}.${FECHA}.log"
 
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
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3

if [ -f ${LCLOG} ]
then
	if [ -s ${LCLOG} ]
	then
		mv ${LCLOG} ${LCLOG}.${FECHA}
		if [ $? != 0 ]
		then 
			Enviar_A_Log "ERROR - Al renombrar el archivo ${LCLOG}." ${LOGSCRIPT}
                	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
  			exit 55
 		else
	 		Enviar_A_Log "AVISO - El archivo ${LCLOG} se renombro exitosamente como ${LCLOG}.${FECHA}." ${LOGSCRIPT}
			>${LCLOG}
                        if [ $? != 0 ]
                        then
                                Enviar_A_Log "ERROR - No se pudo inicializar el archivo ${LCLOG}." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                exit 3
                        else
                                Enviar_A_Log "AVISO - El archivo ${LCLOG} se inicializo exitosamente." ${LOGSCRIPT} 
				Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
				find ${PATHLOG} -name "${PROGRAMA}.*.log" -mtime +7 -exec rm {} \;
				find ${PATHLCLOG} -name "${NOMBRE}.????????" -mtime +7 -exec rm {} \;
		                exit 0
                        fi
		fi
	else
		Enviar_A_Log "ERROR - El archivo ${LCLOG} tiene tamaño 0." ${LOGSCRIPT} 
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
		exit 11
	fi
else
	Enviar_A_Log "ERROR - El archivo ${LCLOG} no existe." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 12
fi
