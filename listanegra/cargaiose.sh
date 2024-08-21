#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: LISTAS_NEGRAS                                          #
# Grupo..............: COMPLETOS                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Carga  completo de Lista Negra de IOSE                 #
# Nombre del programa: cargaiose.sh                                           #
# Nombre del JOB.....: CARGAIOSE                                              #
# Solicitado por.....: Soporte Multistore.                                    #
# Descripcion........:                                                        #
# Creacion...........: 30/04/2010                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="cargaiose"
export PATHAPL="/tecnol/carga_LN"
export PATHBKP="${PATHAPL}/iose"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export ARCHDATA="${PATHAPL}/iose.${FECHA}.txt"
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
if [ -s ${ARCHDATA}.gz ]
then
	Enviar_A_Log "AVISO - Existe la lista iose ${ARCHDATA}." ${LOGSCRIPT}
	gunzip ${ARCHDATA}.gz
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - Al descomprimir ${ARCHDATA}." ${LOGSCRIPT}
		exit 1
	fi
	sqlldr ${USUARIO} control=${SQLCTL} log=${LSTSQLCTL} data=${ARCHDATA} rows=10000  direct=no
	if [ $? != 0 ]
   	then
		Enviar_A_Log "ERROR - No se pudo carga el archivo ${ARCHDATA}." ${LOGSCRIPT}
		exit 2
   	else
      		grep 'SQL*Loader-' ${LSTSQLCTL}
      		if [ $? = 0 ]
         	then 
			Enviar_A_Log "ERROR - Ejecutando sqlldr de archivo ${ARCHDATA}." ${LOGSCRIPT}
            		exit 3
		else
			Enviar_A_Log "AVISO - La carga IOSE termino OK." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
			gzip ${ARCHDATA}
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
                        	exit 0
				fi 
			fi
		fi
	fi
else
	Enviar_A_Log "ERROR - No existe el archivo ${ARCHDATA}.gz." ${LOGSCRIPT}
	exit 12
fi
