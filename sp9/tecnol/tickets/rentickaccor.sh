#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TICKETS                                                #
# Grupo..............: SODEXHOPASS                                            #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Detecta y renombra el archivo                          #
#                      actualiz_coto_nf_YYYYMMDD.txt                          #
# Nombre del programa: rentickaccor.sh                                        #
# Nombre del JOB.....: RENTKACC                                               #
# Descripcion........:                                                        #
# Modificacion.......: 25/09/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="rentickaccor"
export PATHAPL="/tecnol/tickets"
export PATHTICK="/tickets/accor"
export TICKETS="${PATHTICK}/actualiz"
export TICKETSTMP="${PATHTICK}/Actualiz"
export ARCHTICK1="`ls -1 ${TICKETSTMP}_Coto_NF_${FECHA}.txt"
export ARCHTICK2="${TICKETS}.${FECHA}"
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
