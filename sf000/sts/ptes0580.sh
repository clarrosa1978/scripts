#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STS                                                    #
# Grupo..............: CARGA                                                  #
# Autor..............: Miguel Tortolini                                       #
# Objetivo...........: Califica departamentos en devoluciones.                #
# Nombre del programa: ptes0580.sh                                            #
# Nombre del JOB.....: PTES0580                                               #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 13/09/2011                                             #
# Modificacion.......:                                                        #
###############################################################################
set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="ptes0580"
export PATHAPL="/tecnol/sts"
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
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
                sqlplus ${USUARIO} @${SQLGEN} ${LSTSQLGEN}
                if [ $? != 0 ]
                then
			Enviar_A_Log "ERROR - Fallo la ejecucion del sql." ${LOGSCRIPT}
			Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        exit 5
                else
                        if [ -f ${LSTSQLGEN} ]
                        then
                                grep 'ORA-' ${LSTSQLGEN}
                                if [ $? != 0 ] 	
				then
					Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
				 	find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +7 -exec rm {} \;
				 	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
					exit 0
				else
					Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
					Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
					exit 7
				fi
                        else
				Enviar_A_Log "ERROR - No se genero el archivo de spool." ${LOGSCRIPT}
				Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                exit 9
                        fi
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
