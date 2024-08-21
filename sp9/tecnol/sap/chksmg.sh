#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: SAP                                                    #
# Grupo..............: SMG                                                    #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controlar la integridad de archivos SMG                #
# Nombre del programa: chksmg.sh                                              #
# Nombre del JOB.....: CHKSMG                                                 #
# Descripcion........:                                                        #
# Creado.............: 08/04/2015                                             #
# Modificacion.......:                                                        #
# Solicitado por.....: Cristian Larrosa                                       #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export NOMBRE="chksmg"
export PATHAPL="/tecnol/sap"
export PATHLOG="${PATHAPL}/log"
export PATHARCH="/smg"
export ARCHIVOS="acctxt_${FECHA} accadi_${FECHA} acccab_${FECHA}"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"

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
Enviar_A_Log "INICIO - Comienza ejecucion." ${LOG}
for ARCHIVO in ${ARCHIVOS}
do
	if [ -f ${PATHARCH}/${ARCHIVO}.zip ]
	then
		Enviar_A_Log "PROCESO - El archivo ${ARCHIVO}.zip existe." ${LOG}
	else
		Enviar_A_Log "ERROR - No existe el archivo ${ARCHIVO}.zip." ${LOG}
		Enviar_A_Log "ERROR - Reclamar a SMG." ${LOG}
		Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
		exit 1
	fi
done

for ARCHIVO in ${ARCHIVOS}
do
	cd ${PATHARCH}
	unzip -t ${PATHARCH}/${ARCHIVO}.zip
	if [ $? = 0 ]
	then
		Enviar_A_Log "PROCESO - El archivo ${ARCHIVO}.zip no esta corrupto." ${LOG}
		unzip -o ${PATHARCH}/${ARCHIVO}.zip
		if [ $? = 0 ]
		then
			Enviar_A_Log "PROCESO - Descompresion ${ARCHIVO}.zip OK." ${LOG}
			if [ -s ${PATHARCH}/${ARCHIVO}.txt ]
			then
				Enviar_A_Log "PROCESO - Descompresion ${ARCHIVO}.zip OK." ${LOG}
			else
				Enviar_A_Log "AVISO - ${ARCHIVO}.txt tiene size 0." ${LOG}
			fi
		else
			Enviar_A_Log "ERROR - No se pude descomprimir ${PATHARCH}/${ARCHIVO}.zip." ${LOG}
			Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
			exit 1
		fi
	else
	  	Enviar_A_Log "PROCESO - El archivo ${ARCHIVO} esta corrupto. Rearrancar el job SFTPSMG." ${LOG}
               	Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
               	exit 1
	fi
done
Enviar_A_Log "FIN - Finalizacion OK." ${LOG}
exit 0
