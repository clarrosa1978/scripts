#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TICKETS                                                #
# Grupo..............: SODEXHOPASS                                            #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Detectar conexiones ftp con el usuario sfftp.          #
# Nombre del programa: chk_logsfftp.sh                                        #
# Nombre del JOB.....: CHKSFFTP                                               #
# Descripcion........:                                                        #
# Modificacion.......: 25/10/2006                                             #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="chk_logsfftp"
export PATHAPL="/tecnol/tickets"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export DIA="`date +%d`"
export MES="`date +%b`"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
autoload Enviar_A_Log
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
export CONEXION=`last | grep sfftp | grep "${MES} ${DIA}"`
if [ "${CONEXION}" ]
then
	Enviar_A_Log "AVISO - Se detecto conexion del usuario sfftp." ${LOGSCRIPT}
	Enviar_A_Log "AVISO - `echo ${CONEXION}." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
        find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
        exit 0
else
	Enviar_A_Log "ERROR - No se detecto conexion del usuario sfftp." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	exit 20
fi
	
	
