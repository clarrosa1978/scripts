#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: TARJETAS                                               #
# Grupo..............: ICBC                                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Controlar la integridad del archivo		      #
#                      icbc COTO_PAYROLL_VISA_*.txt                           #
# Nombre del programa: chkcbc.sh                                              #
# Nombre del JOB.....: CHKICBC                                                #
# Descripcion........:                                                        #
# Modificacion.......: 23/06/2015                                             #
# Solicitado por.....: Cristian Larrosa                                       #
###############################################################################

set -x
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export NOMBRE="chkcbc"
export PATHAPL="/tecnol/icbc"
export PATHLOG="${PATHAPL}/log"
export PATHARCH="/tarjetas/icbc"
export ARCHIVO1="COTO_PAYROLL_VISA_CREDITO${FECHA}.txt"
export ARCHIVO2="COTO_PAYROLL_VISA_DEBITO${FECHA}.txt"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Controlando existencia de archivos." ${LOG}
if [ -s ${PATHARCH}/${ARCHIVO1} ] 
then
	Enviar_A_Log "AVISO - El archivo ${ARCHIVO1} existe." ${LOG}
else

        Enviar_A_Log "PROCESO - El archivo ${ARCHIVO1} no existe o no tiene datos." ${LOG}
        Enviar_A_Log "ERROR - Reclamar el archivo ${ARCHIVO1} a ICBC." ${LOG}
        Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
	exit 12
fi
if [ -s ${PATHARCH}/${ARCHIVO2} ] 
then
        Enviar_A_Log "AVISO - El archivo ${ARCHIVO2} existe." ${LOG}
        Enviar_A_Log "AVISO - Existen ${ARCHIVO1} y ${ARCHIVO2}." ${LOG}
        Enviar_A_Log "FINALIZACION - OK." ${LOG}
	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
	exit 0
else

        Enviar_A_Log "PROCESO - El archivo ${ARCHIVO2} no existe o no tiene datos." ${LOG}
        Enviar_A_Log "ERROR - Reclamar el archivo ${ARCHIVO2} a ICBC." ${LOG}
        Enviar_A_Log "FIN - Finalizacion con ERROR." ${LOG}
	exit 12
fi
