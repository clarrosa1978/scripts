#!/bin/ksh

###############################################################################
# Aplicacion.........: LISTAS_NEGRAS                                          #
# Grupo..............: COMPLETOS                                              #
# Autor..............: ARAM                                                   #
# Objetivo...........: Controla la existencia, del archivo de TCI a transferir#
# Nombre del programa: cargatci.sh                                            #
# Nombre del JOB.....: CARGATCI                                               #
# Solicitado por.....: Soporte Multistore.                                    #
# Descripcion........:                                                        #
# Creacion...........: 04/08/2011                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="check_tci"
export WORK_DIR="/tecnol/tickets"
export CTRL_FILE="/tarjetas/tci/crudos"
export FILE_BKP="/tarjetas/tci/backup"
export WORK_LOG="${WORK_DIR}/log"
export LOGSCRIPT="${WORK_LOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Principal                                    ###
###############################################################################

autoload Enviar_A_Log
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ ! -f "$CTRL_FILE/listanegraresumentci.txt" ]
then
	Enviar_A_Log "El erchivo LISTANEGRARESUMENTCI a transferir no existe." ${LOGSCRIPT}
	exit 9
fi
mv ${CTRL_FILE}/listanegraresumentci.txt ${FILE_BKP}/listanegraresumentci.${FECHA}.txt
if [ $? = 0 ]
then
	Enviar_A_Log "Se Movio el Archivo ${CTRL_FILE}/LISTANEGRARESUMENTCI.TXT. " ${LOGSCRIPT}
else
	Enviar_A_Log "No se Pudo mover el  archivo ${CTRL_FILE}/LISTANEGRARESUMENTCI.TXT. Abortando..." ${LOGSCRIPT}
	exit 25
fi
gzip ${FILE_BKP}/listanegraresumentci.${FECHA}.txt
if [ "$?" -ne 0 ]
then
       	Enviar_A_Log "ERROR AL COMPRIMIR EL ARCHIVO ${FILE_BKP}/listanegraresumentci.${FECHA}.txt." ${LOGSCRIPT}
       	exit 1
fi
