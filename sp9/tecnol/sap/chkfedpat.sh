#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ART                                                    #
# Grupo..............: FEDPATRONAL                                            #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controlar la integridad de archivos FEDPATRONAL.       #
# Nombre del programa: chkfedpat.sh                                           #
# Nombre del JOB.....: CHKFEDPATACC                                           #
# Descripcion........:                                                        #
# Creado.............: 09/12/2019                                             #
# Modificacion.......:                                                        #
# Solicitado por.....: Cristian Larrosa                                       #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export NOMBRE="chkfedpat"
export PATHAPL="/tecnol/sap"
export PATHLOG="${PATHAPL}/log"
export PATHARCH="/art/fedpatronal"
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
		Enviar_A_Log "ERROR - Reclamar a FEDERACION PATRONAL." ${LOG}
		Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
		exit 1
	fi
done
