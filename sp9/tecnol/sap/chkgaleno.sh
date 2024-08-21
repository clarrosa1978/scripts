#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ART                                                    #
# Grupo..............: GALENO                                                 #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Controlar la integridad de archivos de GALENO.         #
# Nombre del programa: chkgaleno.sh                                           #
# Nombre del JOB.....: CHKGALENOACC                                           #
# Descripcion........:                                                        #
# Creado.............: 15/10/2020                                             #
# Modificacion.......:                                                        #
# Solicitado por.....: Ibar Laura                                             #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export NOMBRE="chkgaleno"
export PATHAPL="/tecnol/sap"
export PATHLOG="${PATHAPL}/log"
export PATHARCH="/art/galeno"
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
	if [ -f ${PATHARCH}/${ARCHIVO}.TXT ]
	then
		Enviar_A_Log "PROCESO - El archivo ${ARCHIVO}.TXT existe." ${LOG}
	else
		Enviar_A_Log "ERROR - No existe el archivo ${ARCHIVO}.TXT." ${LOG}
		Enviar_A_Log "ERROR - Reclamar a GALENO." ${LOG}
		Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
		exit 1
	fi
done
