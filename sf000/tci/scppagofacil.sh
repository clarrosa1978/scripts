#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PAGOFACIL                                              #
# Grupo..............: TCI                     			              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Copia el archivo pfDDMMAA.900 de ctefte a psp1         #
# Nombre del programa: scppagofacil.sh                                        #
# Nombre del JOB.....: SCPPAGFAC                                              #
# Descripcion........:                                                        #
# Modificacion.......: 11/07/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export OPERACION=${1}
export DIRORI=${2}
export DIRDES=${3}
export FECHA=${4}
export DUENO=${5}
export GRUPO=${6}
export PERMISO=${7}
export HOSTDES=${8}
export ARCHDES=${9}
export ANIO="`echo ${FECHA} | cut -c3-4`"
export MES="`echo ${FECHA} | cut -c5-6`"
export DIA="`echo ${FECHA} | cut -c7-8`"
export ARCHORI="pf${DIA}${MES}${ANIO}.900"
export NOMBRE="scppagofacil"
export PATHAPL="/tecnol/tci"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USER="transfer"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 9 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x /tecnol/util/safe_scp ]
then
	/tecnol/util/safe_scp ${OPERACION} ${DIRORI} ${ARCHORI} ${HOSTDES} ${DIRDES} ${ARCHDES} NULL NULL 3 300 NULL ${DUENO} ${GRUPO} ${PERMISO} ${USER}
	if [ $? = 0 ]
	then
		Enviar_A_Log "AVISO - El archivo ${ARCHORI} se transmitio correctamente a ${HOSTDES}." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
                exit 0
	else
		Enviar_A_Log "ERROR - Fallo la transmision del archivo ${ARCHORI} al ${HOSTDES}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 53
	fi
else
	Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando safe_rcp." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
