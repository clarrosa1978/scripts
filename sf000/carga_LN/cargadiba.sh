#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: LISTAS_NEGRAS                                          #
# Grupo..............: COMPLETOS                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Carga  completo de Lista Blanca DIBA                   #
# Nombre del programa: cargadiba.sh                                           #
# Nombre del JOB.....: CARGADIBA                                              #
# Solicitado por.....: Soporte Multistore.                                    #
# Descripcion........:                                                        #
# Creacion...........: 11/05/2012                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="cargadiba"
export PATHAPL="/tecnol/carga_LN"
export PATHBKP="${PATHAPL}/diba"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export ARCHDATA="${PATHAPL}/diba.${FECHA}.txt"
export ARCHBAD="${PATHBKP}/diba.bad"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLCTL="${PATHSQL}/${NOMBRE}.ctl"
export LSTSQLCTL="${PATHLOG}/${NOMBRE}.${FECHA}.lst"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LSTSQLCTL}
Borrar ${ARCHBAD}
if [ -s ${ARCHDATA}.gz ]
then
	Enviar_A_Log "AVISO - Existe ${ARCHDATA}." ${LOGSCRIPT}
	gunzip -f ${ARCHDATA}.gz
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - Al descomprimir ${ARCHDATA}." ${LOGSCRIPT}
		exit 1
	fi
	sqlldr ${USUARIO} control=${SQLCTL} bad=${ARCHBAD} log=${LSTSQLCTL} data=${ARCHDATA} rows=10000  direct=no
	if [ -s ${ARCHBAD} ]
   	then
		Enviar_A_Log "AVISO - Hubo registros duplicados." ${LOGSCRIPT}
   	else
		Enviar_A_Log "AVISO - La carga DIBA termino OK." ${LOGSCRIPT}
		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
	fi
	gzip -f ${ARCHDATA}
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - Al Comprimir ${ARCHDATA}." ${LOGSCRIPT}
		exit 4
	else
		mv "${ARCHDATA}.gz" "${PATHBKP}"
		if [ $? != 0 ]
		then
			Enviar_A_Log "ERROR - Al mover el archivo ${ARCHDATA}.gz a ${PATHBKP}." ${LOGSCRIPT}
			exit 5
		else
			find ${PATHLOG} -name "${NOMBRE}*" -mtime +35 -exec rm {} \;
			find ${PATHBKP} -name "${ARCHDATA}*" -mtime +365 -exec rm {} \;
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                       	exit 0
		fi 
	fi
else
	Enviar_A_Log "ERROR - No existe el archivo ${ARCHDATA}.gz." ${LOGSCRIPT}
	exit 12
fi
