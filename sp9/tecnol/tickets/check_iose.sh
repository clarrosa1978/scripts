#!/bin/ksh
###############################################################################
# Aplicacion.........: LISTAS_NEGRAS                                          #
# Grupo..............: COMPLETOS                                              #
# Autor..............: ARAM                                                   #
# Objetivo...........: Controla la existencia del archivo de IOSE a transferir#
# Nombre del programa: check_iose.sh                                          #
# Nombre del JOB.....: CTRLIOSE                                               #
# Solicitado por.....: Soporte Multistore.                                    #
# Descripcion........:                                                        #
# Creacion...........: 04/08/2011                                             #
###############################################################################

set -x
export FECHA=${1}
export NOMBRE="check_iose"
export WORK_DIR="/tecnol/tickets"
export WORK_LOG="${WORK_DIR}/log"
export LOGSCRIPT="${WORK_LOG}/${NOMBRE}.${FECHA}.log"
export CTRL_FILE="/tarjetas/iose/crudos"
export FILE_BKP="/tarjetas/iose/backup"
export ARCH_BKP="COTO"
export ARCHIVO="iose"

###############################################################################
###                            Principal                                    ###
###############################################################################

autoload Enviar_A_Log
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ ! -s "$CTRL_FILE" ]
then
	Enviar_A_Log "El erchivo ${ARCH_BKP}.ZIP a transferir no existe." ${LOGSCRIPT}
	exit 9
fi
mv ${CTRL_FILE}/${ARCH_BKP}.ZIP ${FILE_BKP}/${ARCH_BKP}.${FECHA}.ZIP
	if [ $? = 0 ]
        then
		Enviar_A_Log "Se Movio el Archivo ${ARCH_BKP}.ZIP. " ${LOGSCRIPT}
	else
		Enviar_A_Log "No se Pudo mover el  archivo ${ARCH_BKP}.ZIP. Abortando..." ${LOGSCRIPT}
		exit 25
	fi
cd ${FILE_BKP}
	if [ $? = 0 ]
	then 
		echo " "
	else
		Enviar_A_Log "No existe el DIRECTORIO ${FILE_BKP}." ${LOGSCRIPT}
		exit 1
	fi
unzip ${FILE_BKP}/${ARCH_BKP}.${FECHA}.ZIP  
	if [ $? = 0 ]
	then
		Enviar_A_Log "SE DESPOMPRIME EL ARCHIVO ${ARCH_BKP}.ZIP." ${LOGSCRIPT}
	else
		Enviar_A_Log "ERROR AL DESCOMPRIMIR EL ARCHIVO ${ARCH_BKP}.ZIP." ${LOGSCRIPT}
		exit 1
	fi
cat ${FILE_BKP}/${ARCH_BKP}.TXT | tr -d "\r" > ${FILE_BKP}/${ARCHIVO}.${FECHA}.txt
	if [ "$?" -ne 0 ]
        then
		Enviar_A_Log "ERROR AL QUITAR ^M o fin de linea en Unix del ${ARCHIVO}.${FECHA}.txt." ${LOGSCRIPT}
		exit 1
	fi
gzip -f ${FILE_BKP}/${ARCHIVO}.${FECHA}.txt
	if [ "$?" -ne 0 ]
	then
        	Enviar_A_Log "ERROR AL COMPRIMIR EL ARCHIVO ${ARCHIVO}.${FECHA}.txt}." ${LOGSCRIPT}
        	exit 1
	else
		rm ${FILE_BKP}/${ARCH_BKP}.TXT
			if [ "$?" -ne 0 ]
			then
				Enviar_A_Log "ERROR NO SE PUDO BORRAR EL ARCHIVO ${ACH_BKP}.ZIP." ${LOGSCRIPT}
			exit 3
			fi
	fi
#
