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
export NOMBRE="cargacotovf"
export PATHAPL="/tecnol/ministerio"
export PATHCSV="${PATHAPL}/txt"
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

if [ `cd ${PATHAPL}/txt && ls -1 *.txt | wc -l` = 1 ]
then
	export ARCHIVO="`cd ${PATHAPL}/txt && ls -1 *.txt`"
	export ARCHDATA="${PATHCSV}/${ARCHIVO}"
	mv "${ARCHDATA}" ${PATHCSV}/nominacoto.txt
	if [ $? != 0 ]
	then
		Enviar_A_Log "ERROR - No se pudo cambiar el nombre del archivo." ${LOGSCRIPT}
		exit 5
	else
                Enviar_A_Log "INFO - Existe archivo para procesar." ${LOGSCRIPT}
                export ARCHDATA=${PATHCSV}/nominacoto.txt
                export ARCHIVO=nominacoto.txt
        fi
else
	Enviar_A_Log "ERROR - No existe un archivo para procesar." ${LOGSCRIPT}
	exit 5
fi
	
if [ -s "${ARCHDATA}" ]
then
	sqlldr ${USUARIO} DATA=${ARCHDATA},CONTROL=${SQLCTL},LOG=${LSTSQLCTL},ROWS=10000,ERRORS=9999999,BAD=${ARCHBAD},DISCARD=${PATHLOG}/discard.log
	if [ $? != 0 ]
   	then
		grep -i ORA-00001 ${LSTSQLCTL}
		if [ $? != 0 ]
		then
			Enviar_A_Log "ERROR - No se pudo cargar algunos registros en la base." ${LOGSCRIPT}
			cat ${LSTSQLCTL}
			mv ${ARCHDATA} ${PATHCSV}/error
			exit 2
   		else
			Enviar_A_Log "AVISO - Se encontraron registrdos duplicados." ${LOGSCRIPT} 
      			grep 'SQL*Loader-' ${LSTSQLCTL}
      			if [ $? = 0 ]
         		then 
				Enviar_A_Log "ERROR - Ejecutando sqlldr de archivo ${ARCHDATA}." ${LOGSCRIPT}
            			exit 3
			else
				Enviar_A_Log "AVISO - La carga del archivo del ministerio termino OK." ${LOGSCRIPT}
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
						find ${PATHBKP} -name "*.txt" -mtime +365 -exec rm {} \;
                        			exit 0
					fi
				fi 
			fi
		fi
	else
		Enviar_A_Log "AVISO - La carga del archivo del ministerio termino OK." ${LOGSCRIPT}
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
                                find ${PATHBKP} -name "*.txt" -mtime +365 -exec rm {} \;
                                exit 0
			fi
		fi
	fi
else
	Enviar_A_Log "ERROR - No existe el archivo ${ARCHDATA}." ${LOGSCRIPT}
	exit 12
fi
