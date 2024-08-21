#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: LISTAS_NEGRAS                                          #
# Grupo..............: COMPLETOS                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Carga tarjetas TCI incobrables.                        #
# Nombre del programa: cargatci.sh                                            #
# Nombre del JOB.....: CARGATCI                                               #
# Solicitado por.....: Administracion Unix                                    #
# Descripcion........:                                                        #
# Creacion...........: 26/05/2010                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="cargatci"
export PATHAPL="/tecnol/carga_LN"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export ARCHDATA="${PATHAPL}/listanegraresumentci.txt"
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
Borrar ${LSTSQLCTL}.lst
if [ -f ${SQLCTL} ]
then
	if [ -s ${ARCHDATA} ]
	then
        	sqlldr ${USUARIO} control=${SQLCTL} log=${LSTSQLCTL} data=${ARCHDATA} rows=10000  direct=no
        	if [ $? != 0 ]
        	then
                	Enviar_A_Log "ERROR - Ejecutando sqlldr de ${ARCHDATA}." ${LOGSCRIPT}
                	exit 5
        	else
                	grep 'SQL*Loader-' ${LSTSQLCTL}
                	if [ $? = 0 ]
                	then
                        	Enviar_A_Log "ERROR - Ejecutando sqlldr de ${ARCHDATA}." ${LOGSCRIPT}
                        	exit 5
                	else
                        	Enviar_A_Log "FINALIZACION - La carga de ${ARCHDATA} termino OK." ${LOGSCRIPT}
                        	find ${PATHLOG} -name "${NOMBRE}*" -mtime +35 -exec rm {} \;
                        	exit 0
                	fi
        	fi
	else
        	Enviar_A_Log "ERROR - No existe el archivo ${ARCHDATA}." ${LOGSCRIPT}
        	exit 12
	fi
else
	Enviar_A_Log "ERROR - No existe el archivo ${SQLCTL}." ${LOGSCRIPT}
	exit 12
fi
