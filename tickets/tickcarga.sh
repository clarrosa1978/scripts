#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TICKETS-ZE                                             #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Cargar archivo de tickets recibido como parametro.     #
# Nombre del programa: tickcarga.sh                                           #
# Nombre del JOB.....: ZTKXXXXXXX                                             #
# Descripcion........: Carga el archivo de tickets pasado por parametro.      #
# Modificacion.......: 01/09/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export TICKETS=${2}
export NOMBRE="tickcarga"
export PATHAPL="/tecnol/tickets"
export PROGRAMA="/sfctrl/sfgv/bin/tickCarga"
export PATHTICK="/sfctrl/data/carga"
export ARCHMESS="/sfctrl/data/mess_f1.dat"
export ARCHTICK="${PATHTICK}/${TICKETS}.${FECHA}"
export PARM=${3}
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
Check_Par 3 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -s ${ARCHTICK} ]
then
	Enviar_A_Log "AVISO - Se detecto el archivo ${ARCHTICK}." ${LOGSCRIPT}
	if [ -x ${PROGRAMA} ]
	then
		if [ ${TICKETS} = "co" ]
		then
			${PROGRAMA} ${PARM} ${ARCHTICK} ${ARCHMESS} AGREGAR
		else
			${PROGRAMA} ${PARM} ${ARCHTICK} ${ARCHMESS}
		fi
        	if [ $? = 0 ]
        	then
			Enviar_A_Log "FINALIZACION - Carga de Tickets de Mastercard OK." ${LOGSCRIPT}
                        find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
			find ${PATHTICK} -name "${TICKETS}*" -mtime +7 -exec rm {} \;
                	exit 0
		else
			Enviar_A_Log "ERROR - Fallo la carga de los tickets de Mastercard." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
			exit 5
		fi
        else
	        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el programa ${PROGRAMA}." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        	exit 88
        fi
else
	        Enviar_A_Log "ERROR - No exite el archivo ${ARCHTICK}$." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 12
fi
