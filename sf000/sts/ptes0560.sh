#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: INTERFACE-CTC-STS                                      #
# Grupo..............: LD-CTC-STS                                             #
# Autor..............:                                                        #
# Nombre del programa: ptes0560.sh                                            #
# Nombre del JOB.....: PTES0560                                               #
# Solicitado por.....: Leonardo Bernedo                                       #
# Descripcion........: Carga cierres de lotes posnet.                         #
# Creacion...........: 21/07/2010                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="ptes0560"
export PATHAPL="/tecnol/sts"
export PATHARC="/sts/posnets/enproceso"
export PATHPRO="/sts/posnets/procesados"
export PATHERR="/sts/posnets/erroneos"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"

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
Borrar ${LSTSQLGEN}
[ $? != 0 ] && exit 99
if [  -d  "$PATHARC" -a -d "$PATHPRO" -a -d "$PATHERR" ] 
then
	echo "Directorios Validos"
else 
	exit 22
fi
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
	if [ -r ${SQLGEN} ]
        then
		cd $PATHARC
		if [ $? != 0 ]
		then
       			echo "No se pudo acceder a ${SOURCE_DIR}"
        		exit 2
		fi
		CONTROL="`ls *`"
		Enviar_A_Log "PROCESO - Controlo si hay archivos con nombre mas largo." ${LOGSCRIPT}
		if [ "${CONTROL}" ]
		then
			#Agregado debido a que POSNET agrego hora y minutos al nombre del archivo
			for i in `ls -1 *.????????????.???`
			do 
				ARCHNEW="`echo $i | cut -c 1-17,22-`"
				echo Enviar_A_Log "PROCESO - Renombro $i como ${ARCHNEW}." ${LOGSCRIPT}
				mv $i $ARCHNEW
			done
			for ARCHIVO in `ls *` 
			do
				if [ $? != 0 ]
				then
        				echo "No se encontraron ARCHIVOS"
        				exit 2
				fi
				sqlplus ${USUARIO} @${SQLGEN} ${ARCHIVO} ${LSTSQLGEN}
                		if [ $? != 0 ]
                		then
                        		Enviar_A_Log "ERROR - Fallo la ejecucion del sql cargando ${ARCHNEW}." ${LOGSCRIPT}
                        		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        		exit 5
                		else
                        		if [ -f ${LSTSQLGEN} ]
                        		then
                                		grep 'ORA-' ${LSTSQLGEN}
                                		if [ $? != 0 ]  
                                		then
                                        		Enviar_A_Log "PROCESO - Carga de ${ARCHIVO} OK." ${LOGSCRIPT}
							mv $ARCHIVO $PATHPRO
							if [ $? != 0 ]
							then
        							echo "Error el mover ${ARCHIVO}"
        							exit 2
							fi
                                		else
                                        		Enviar_A_Log "ERROR - Error de Oracle - Archivo: ${ARCHIVO}." ${LOGSCRIPT}
							mv $ARCHIVO $PATHERR
							if [ $? != 0 ]
							then
        							echo "Error el mover ${ARCHIVO}"
        							exit 2
							fi
                                		fi
                        		else
                                		Enviar_A_Log "ERROR - No se genero el archivo de spool." ${LOGSCRIPT}
                                		Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                		exit 9
                        		fi
                		fi
			done
                        Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
        		find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +7 -exec rm {} \;
        		find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
			exit 0
		else
			Enviar_A_Log "ERROR - No hay archivos para procesar." ${LOGSCRIPT}
                	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                	exit 4
		fi
	else
               	Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${SQLGEN}." ${LOGSCRIPT}
               	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
               	exit 77
        fi
else
       	Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando sqlplus." ${LOGSCRIPT}
       	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
       	exit 88
fi
