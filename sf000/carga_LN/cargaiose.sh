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
export ARCHBAD="${PATHBKP}/iose.bad"
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
	cat ${ARCHDATA} | sort | uniq > ${ARCHDATA}.tmp
	sqlldr ${USUARIO} control=${SQLCTL} log=${LSTSQLCTL} bad=${ARCHBAD} data=${ARCHDATA}.tmp rows=10000 
	if [ -s ${LSTSQLCTL} ]
   	then
      		grep 'ORA-00001' ${LSTSQLCTL}
      		if [ $? = 0 ]
         	then 
			Enviar_A_Log "AVISO - Hay registros duplicados, se toma como OK la carga." ${LOGSCRIPT}
            		EXIT=0
		fi
		grep 'ORA-01722' ${LSTSQLCTL}
		if [ $? = 0 ]
		then
			Enviar_A_Log "AVISO - Hay registros invalidos, se toma como OK la carga." ${LOGSCRIPT}
			EXIT=0
		fi
	else
		Enviar_A_Log "ERROR - No se pudo carga el archivo ${ARCHDATA}." ${LOGSCRIPT}
                exit 2
	fi
	Enviar_A_Log "AVISO - La carga IOSE termino OK." ${LOGSCRIPT}
	Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
	rm -f ${ARCHDATA}.tmp
	gzip -f ${ARCHDATA}
	mv "${ARCHDATA}.gz" "${PATHBKP}"
	find ${PATHLOG} -name "${NOMBRE}*" -mtime +35 -exec rm {} \;
	find ${PATHBKP} -name "${ARCHDATA}*" -mtime +365 -exec rm {} \;
        exit $EXIT
else
	Enviar_A_Log "ERROR - No existe el archivo ${ARCHDATA}.gz." ${LOGSCRIPT}
	exit 12
fi
