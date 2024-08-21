#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ART                                                    #
# Grupo..............: PREVENCION                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controlar la integridad de archivos PREVENCION.        #
# Nombre del programa: chkprev.sh                                             #
# Nombre del JOB.....: CHKPREV                                                #
# Descripcion........:                                                        #
# Creado.............: 08/06/2018                                             #
# Modificacion.......:                                                        #
# Solicitado por.....: Cristian Larrosa                                       #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export NOMBRE="chkprev"
export PATHAPL="/tecnol/sap"
export PATHLOG="${PATHAPL}/log"
export PATHARCH="/art/prevencion"
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
	if [ -f ${PATHARCH}/${ARCHIVO}.txt ]
	then
		Enviar_A_Log "PROCESO - El archivo ${ARCHIVO}.txt existe." ${LOG}
	else
		Enviar_A_Log "ERROR - No existe el archivo ${ARCHIVO}.txt." ${LOG}
		Enviar_A_Log "ERROR - Reclamar a SANCOR SEGUROS." ${LOG}
		Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
		exit 1
	fi
done
