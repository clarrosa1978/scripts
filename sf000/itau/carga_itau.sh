#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ITAU                                                   #
# Grupo..............: CLIENTES                                               #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Carga lista blanca banco itau.                         #
# Nombre del programa: carga_itau.sh                                          #
# Nombre del JOB.....: CARGAITAUXXXXXXX                                       #
# Solicitado por.....: Soporte Multistore.                                    #
# Descripcion........:                                                        #
# Creacion...........: 28/04/2023                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export FILE=${2}
export NOMBRE="carga_itau"
export PATHAPL="/tecnol/itau"
export PATHCSV="${PATHAPL}/txt"
export PATHBKP="${PATHCSV}/procesados"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FILE}.${FECHA}.log"
export USUARIO="/"
export ARCHBAD="${PATHLOG}/${NOMBRE}.${FILE}.bad"
export SQLCTL="${PATHSQL}/${NOMBRE}.${FILE}.ctl"
export LSTSQLCTL="${PATHLOG}/${NOMBRE}.${FILE}.${FECHA}.lst"


###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LSTSQLCTL}
case "$FILE" in
	"VISAFN")	export ARCHIVO="Itau_COTO_CD_Visa_FN_${FECHA}.txt"
			;;
        "VISAPB") 	export ARCHIVO="Itau_COTO_CD_Visa_PB_${FECHA}.txt"
                	;;
	"MASTERFN")	export ARCHIVO="Itau_COTO_CD_Master_FN_${FECHA}.txt"
			;;
        "MASTERPB")     export ARCHIVO="Itau_COTO_CD_Master_PB_${FECHA}.txt"
                        ;;
esac
export ARCHDATA="${PATHCSV}/${ARCHIVO}"
if [ -s "${ARCHDATA}" ]
then
	sqlldr ${USUARIO} DATA=${ARCHDATA},CONTROL=${SQLCTL},LOG=${LSTSQLCTL},ROWS=10000,ERRORS=9999999,BAD=${ARCHBAD},DISCARD=${PATHLOG}/discard.log
	if [ $? != 0 ]
   	then
		grep -i ORA-01722 ${LSTSQLCTL}
		if [ $? != 0 ]
		then
			Enviar_A_Log "ERROR - No se pudo cargar algunos registros en la base." ${LOGSCRIPT}
			cat ${LSTSQLCTL}
			exit 2
   		else
      			grep 'SQL*Loader-' ${LSTSQLCTL}
      			if [ $? = 0 ]
         		then 
				Enviar_A_Log "ERROR - Ejecutando sqlldr de archivo ${ARCHDATA}." ${LOGSCRIPT}
            			exit 3
			else
				Enviar_A_Log "AVISO - La carga del archivo de Santander termino OK." ${LOGSCRIPT}
				Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
				gzip ${ARCHDATA}
				if [ $? != 0 ]
				then
					Enviar_A_Log "ERROR - Al Comprimir ${ARCHDATA}." ${LOGSCRIPT}
					exit 4
				else
					mv "${ARCHDATA}.gz" "${PATHBKP}/${ARCHIVO}.gz"
					if [ $? != 0 ]
					then
						Enviar_A_Log "ERROR - Al mover el archivo ${ARCHDATA} a ${PATHBKP}." ${LOGSCRIPT}
						exit 5
					else
						find ${PATHLOG} -name "${NOMBRE}*" -mtime +35 -exec rm {} \;
						find ${PATHBKP} -name "*.txt" -mtime +365 -exec rm {} \;
                        			exit 0
					fi
				fi 
			fi
		fi
	else
		Enviar_A_Log "AVISO - La carga del archivo ${ARCHDATA} termino OK." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                gzip ${ARCHDATA}
                if [ $? != 0 ]
                then
               		Enviar_A_Log "ERROR - Al Comprimir ${ARCHDATA}." ${LOGSCRIPT}
                        exit 4
                else
                        mv "${ARCHDATA}.gz" "${PATHBKP}/${ARCHIVO}.gz"
                        if [ $? != 0 ]
                        then
                        	Enviar_A_Log "ERROR - Al mover el archivo ${ARCHDATA} a ${PATHBKP}." ${LOGSCRIPT}
                                exit 5
                        else
                                find ${PATHLOG} -name "${NOMBRE}.${FILE}*" -mtime +35 -exec rm {} \;
                                find ${PATHBKP} -name "*.txt" -mtime +365 -exec rm {} \;
                                exit 0
			fi
		fi
	fi
else
	Enviar_A_Log "ERROR - No existe el archivo ${ARCHDATA}." ${LOGSCRIPT}
	exit 12
fi
