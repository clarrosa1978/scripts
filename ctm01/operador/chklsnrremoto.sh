#!/bin/sh
exit 0
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Chequea el listener recibido como parametro en servidor#
#                      secundario.                                            #
# Nombre del programa: chklsnrremoto.sh                                       #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 06/02/2013                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

#set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="`date +%Y%m%d`"
export SUC="`uname -n | sed 's/suc//'`"
export SERVREM="nodo2"
export LSN=${1}
export NOMBRE="chklsnrremoto"
export PATHAPL="/tecnol/operador"
export FPATH="/tecnol/funciones"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
typeset -fu Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
if [ $SUC -lt 100 ]
then
	SUC=0$SUC
fi
ESTA="`ssh ${SERVREM} ps -ef | grep oracle | grep -v grep | grep tnslsnr | grep ${LSN}${SUC}`"
if [ "${ESTA}" ]
then
	echo "\n\t\t${ESTA}\n"
	Enviar_A_Log "El listener esta en ejecucion." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
else
        Enviar_A_Log "ERROR - El listener ${LSN}${SUC} no esta en ejecucion!!!!." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
fi
echo "\n\t\t\t\t${REV}Presione una tecla para continuar...${EREV}"
read
