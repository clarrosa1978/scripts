#!/bin/ksh
###############################################################################
# Aplicacion.........: MENU OPERACIONES SUCURSAL                              #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Chequea el listener recibido como parametro.           #
# Nombre del programa: chklsnr.sh                                             #
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
export LSN=${1}
export NOMBRE="chklsnr"
export PATHAPL="/tecnol/operador"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export FPATH=/tecnol/funciones


###############################################################################
###                            Funciones                                    ###
###############################################################################
ksh autoload Borrar
ksh autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
if [ $SUC -lt 100 ]
then
	SUC=0$SUC
fi


ESTA="`ps -ef | grep oracle | grep -v grep | grep tnslsnr | grep ${LSN}${SUC}`"
if [ "${ESTA}" ]
then
	Enviar_A_Log "El listener esta en ejecucion en `uname -n`." ${LOGSCRIPT}
	echo "${ESTA}"
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
else
	ESTA1="`ps -ef | grep oracle | grep -v grep | grep tnslsnr | grep ${LSN}`"
	if [ "${ESTA1}" ]
	then
	        Enviar_A_Log "El listener esta en ejecucion en `uname -n`." ${LOGSCRIPT}
        	echo "${ESTA1}"
        	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
	else
	        Enviar_A_Log "ERROR - El listener ${LSN}${SUC} no esta en ejecucion!!!!." ${LOGSCRIPT}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
	fi
fi
echo "\n${REV}Presione una tecla para continuar...${EREV}"
read
