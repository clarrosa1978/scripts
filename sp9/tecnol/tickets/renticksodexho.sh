#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TICKETS                                                #
# Grupo..............: SODEXHOPASS                                            #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Detecta y renombra el archivo                          #
#                      tktinv2.txt.                                           #
# Nombre del programa: rentickmaster.sh                                       #
# Nombre del JOB.....: RENTKSOD                                               #
# Descripcion........:                                                        #
# Modificacion.......: 18/09/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="renticksodexho"
export PATHAPL="/tecnol/tickets"
export PATHTICK="/tickets/sodexhopass"
export TICKETS="${PATHTICK}/tktinv"
export ARCHTICK1="`ls -1 ${TICKETS}2.txt"
export ARCHTICK2="${TICKETS}.${FECHA}.txt"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log
autoload Check_Par
autoload Borrar

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ ${ARCHTICK1} ]
then
	Enviar_A_Log "AVISO - El archivo ${ARCHTICK1} existe." ${LOGSCRIPT}
	cat ${ARCHTICK1} | tr "\015" "@" | sed s/@//g >${ARCHTICK2}
       	if [ $? = 0 ]
       	then
		rm -f ${ARCHTICK1}
		Enviar_A_Log "AVISO - Archivo ${ARCHTICK1} renombrado como ${ARCHTICK2} correctamente." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
		find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
		exit 0
	else
		Enviar_A_Log "ERROR - No se pudo renombrar el archivo ${ARCHTICK1}." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 55
       	fi       
else
    	Enviar_A_Log "ERROR - No existe el archivo ${ARCHTICK1}." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 12
fi
