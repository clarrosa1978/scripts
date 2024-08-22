#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: GDM                                                    #
# Grupo..............: PRECIOS                                                #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Chequea las diferencias entre el offset procesado y el #
#                      tamaño del tlog activo.                                #
# Nombre del programa: chkdiftlog.sh                                          #
# Nombre del JOB.....: CHKDIFLOG                                              #
# Descripcion........: Calcula la diferencia en bytes entre el tamaño del tlog#
#                      y la cantidad de bytes procesadas por el 41507.        #
# Modificacion.......: 09/03/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export HORA="`date +%H%M`"
export NOMBRE="chkdiftlog"
export PATHAPL="/tecnol/gdm"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export ARCHIVO1="${PATHLOG}/count5450700.${FECHA}.lst"
export SIZEOFFS=""
export ARCHIVO2="${PATHLOG}/counttlog.${FECHA}.lst"
export SIZETLOG=""
export DIFERENCIA=""
export SIZETOPE=1500
export HORATOPE=0030

###############################################################################
###                            Principal                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
Check_Par 1 $@
[ $? != 0 ] && exit 1
autoload Enviar_A_Log
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -s ${ARCHIVO1} ]
then
	SIZEOFFS="`cat ${ARCHIVO1}`"
	if [ ${SIZEOFFS} ]
	then
		EsNumerico ${SIZEOFFS}
		if [ $? != 0 ]
		then
			Enviar_A_Log "ERROR - Tipo de dato incorrecto en variable SIZEOFFS." ${LOGSCRIPT}
        		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        		exit 100
		fi
	else
		Enviar_A_Log "ERROR - La variable SIZEOFFS esta vacia." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        	exit 4
	fi
else
	Enviar_A_Log "ERROR - El archivo ${ARCHIVO1} no existe." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 12
fi

if [ -s ${ARCHIVO2} ]
then
        SIZETLOG="`cat ${ARCHIVO2}`"
        if [ ${SIZETLOG} ]
        then
                EsNumerico ${SIZETLOG}
                if [ $? != 0 ]
                then    
                        Enviar_A_Log "ERROR - Tipo de dato incorrecto en variable SIZETLOG." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 100
                fi
        else
                Enviar_A_Log "ERROR - La variable SIZETLOG esta vacia." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 4
        fi
else
        Enviar_A_Log "ERROR - El archivo ${ARCHIVO2} no existe." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 12
fi

let "DIFERENCIA=${SIZETLOG} - ${SIZEOFFS}"
if [ ${DIFERENCIA} -ge 0 ] && [ ${DIFERENCIA} -le ${SIZETOPE} ]
then
	Enviar_A_Log "AVISO - La diferencia de tamaño del offset esta dentro del rango." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
        find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
        exit 0
else
	if [ ${HORA} -gt ${HORATOPE} ]
	then
		Enviar_A_Log "AVISO - Son mas de las ${HORATOPE} am, continua la ejecucion del batch." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
		find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
		exit 0
	else
	        Enviar_A_Log "AVISO - Falta procesar ${DIFERENCIA} bytes y aun no son las ${HORATOPE} am , se arranca nuevamente el CPR09." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
        	exit 200
	fi
fi
