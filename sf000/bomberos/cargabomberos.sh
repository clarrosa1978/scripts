#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: BOMBEROS                                               #
# Grupo..............: CARGA                                                  #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Carga lista blanca bomberos voluntarios                #
# Nombre del programa: cargabomberos.sh                                       #
# Nombre del JOB.....: CARGBOMBEROS                                           #
# Solicitado por.....: Soporte Multistore.                                    #
# Descripcion........:                                                        #
# Creacion...........: 07/20/2020                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="cargabomberos"
export PATHAPL="/tecnol/bomberos"
export PATHCSV="${PATHAPL}/csv"
export PATHBKP="${PATHCSV}/procesados"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export ARCHBAD="${PATHLOG}/${NOMBRE}.bad"
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

if [ `cd ${PATHAPL}/csv && ls -1 *.csv | wc -l` = 1 ]
then
	export ARCHIVO="`cd ${PATHAPL}/csv && ls -1 *.csv`"
	export ARCHDATA="${PATHCSV}/${ARCHIVO}"
	rm -f ${PATHCSV}/bomberos.csv.rec
	mv -f "${ARCHDATA}" ${PATHCSV}/bomberos.csv
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - No se pudo cambiar el nombre del archivo." ${LOGSCRIPT}
		exit 5
	else
                Enviar_A_Log "INFO - Existe archivo para procesar." ${LOGSCRIPT}
                export ARCHDATA=${PATHCSV}/bomberos.csv
                export ARHCHIVO=bomberos.csv
        fi
else
	Enviar_A_Log "ERROR - No existe un archivo para procesar." ${LOGSCRIPT}
	exit 5
fi
	
if [ -s "${ARCHDATA}" ]
then
#awk -F";" '$3~/[0-9]{5,8}/ { print $3}' "${ARCHDATA}" | sort -u | egrep -v "00000|000000|0000000|00000000" > "${ARCHDATA}".rec
	awk -F";" '$1~/[0-9]{5,8}/ { print $1}' "${ARCHDATA}" | sed 's/"//g' | sort -u > "${ARCHDATA}".rec
	if [ ! -s "${ARCHDATA}".rec ]
	then
 	       	Enviar_A_Log "ERROR - El archivo ${ARCHDATA}.rec generado no tiene datos." ${LOGSCRIPT}
        	exit 12
	fi
	sqlldr ${USUARIO} control=${SQLCTL} log=${LSTSQLCTL} data="${ARCHDATA}".rec rows=100000 BAD=${ARCHBAD} DISCARD=${PATHLOG}/discard.log
	if [ $? = 0 ]
   	then
		grep -i ORA-01722 ${LSTSQLCTL}
		if [ $? != 1 ]
		then
			Enviar_A_Log "ERROR - No se pudo cargar algunos registros en la base." ${LOGSCRIPT}
			exit 0
   		else
      			grep 'SQL*Loader-' ${LSTSQLCTL}
      			if [ $? = 0 ]
         		then 
				Enviar_A_Log "ERROR - Ejecutando sqlldr de archivo ${ARCHDATA}." ${LOGSCRIPT}
            			exit 3
			else
				Enviar_A_Log "AVISO - La carga del archivo de Bomberos termino OK." ${LOGSCRIPT}
				Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
				gzip ${ARCHDATA}
				if [ $? != 0 ]
				then
					Enviar_A_Log "ERROR - Al Comprimir ${ARCHDATA}." ${LOGSCRIPT}
					exit 4
				else
					mv "${ARCHDATA}.gz" "${PATHBKP}/${ARCHIVO}.${FECHA}.gz"
					if [ $? != 0 ]
					then
						Enviar_A_Log "ERROR - Al mover el archivo ${ARCHDATA} a ${PATHBKP}." ${LOGSCRIPT}
						exit 5
					else
						find ${PATHLOG} -name "${NOMBRE}*" -mtime +35 -exec rm {} \;
						find ${PATHBKP} -name "*.csv" -mtime +365 -exec rm {} \;
                        			exit 0
					fi
				fi 
			fi
		fi
	 else
		Enviar_A_Log "ERROR - Fallo la ejecucion del sqlldr." ${LOGSCRIPT}
		exit 1
	fi
else
	Enviar_A_Log "ERROR - No existe el archivo ${ARCHDATA}." ${LOGSCRIPT}
	exit 12
fi