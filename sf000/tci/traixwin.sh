#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PAGOFACIL                                              #
# Grupo..............: TCI                     			              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Cambia pfDDMMYY.900 de formato unix a windows.         #
# Nombre del programa: traixwin.sh                                            #
# Nombre del JOB.....: TAWPAGFAC                                              #
# Descripcion........:                                                        #
# Modificacion.......: 16/03/2007                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA="${1}"
export DIA="`echo ${FECHA} | cut -c7-8`"
export MES="`echo ${FECHA} | cut -c5-6`"
export ANO="`echo ${FECHA} | cut -c1-4`"
export PATHARCH="/pagofacil"
export NOMBRE="traixwin"
export ARCHIVO1="${PATHARCH}/pf${DIA}${MES}`echo ${ANO} | cut -c3-4`.900"
export ARCHIVO2="${PATHARCH}/pf${FECHA}.900.dat"
export PATHAPL="/tecnol/tci"
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
if [ -s ${ARCHIVO1} ]
then
	sudo cat ${ARCHIVO1} | awk ' { print sprintf("%s@", $0) } ' | tr "@" "\015" > ${ARCHIVO2}
	if [ $? = 0 ]
	then
		Enviar_A_Log "AVISO - El archivo ${ARCHIVO2} se genero correctamente." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                sudo find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
                sudo find ${PATHARCH} -name "pf????????.900.dat" -mtime +1 -exec rm {} \;
                exit 0
	else
		Enviar_A_Log "ERROR - Fallo la generacion del archivo ${ARCHIVO2}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 3
	fi
else
	Enviar_A_Log "ERROR - El archivo ${ARCHIVO1} no existe." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 12
fi
