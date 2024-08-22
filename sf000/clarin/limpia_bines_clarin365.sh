#!/usr/bin/ksh
###############################################################################
# Nombre del JOB.....: LCLARIN                                                #
# Aplicacion.........: TARJETAS                                               #
# Grupo..............: CLARIN                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Borra registros de las tarjetas Clarin existentes.     #
# Nombre del programa: limpia_bines_clarin365.sh                              #
# Solicitado por.....: Jose Chariano                                          #
# Descripcion........:                                                        #
# Creacion...........: 15/04/2011                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="limpia_bines_clarin365"
export PATHAPL="/tecnol/clarin"
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
				 	find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +30 -exec rm {} \;
				 	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +30 -exec rm {} \;
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
