#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STOREFLOW                                              #
# Grupo..............: PREPARADO                                              #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Actualiza el campo NLOGPROC de la tabla T6040800       #
# Nombre del programa: upd_t6040800.sh                                        r
# Nombre del JOB.....: T6040800                                               #
# Descripcion........: Actualiza la tabla T6040800.                           #
# Modificacion.......: 04/04/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="upd_t6040800"
export PATHAPL="/tecnol/preparado"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export PATHTLOG="/sfctrl/d"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log
autoload Check_Par


###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
TLOG="`ls -1t ${PATHTLOG}/tlog??.dat | head -1 | cut -c15,16`"
if [ ${TLOG} ]
then
	if [ -x $ORACLE_HOME/bin/sqlplus ]
	then
        	if [ -r ${SQLGEN} ]
        	then
                	sqlplus ${USUARIO} @${SQLGEN} ${TLOG} ${LSTSQLGEN}
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
else
	 Enviar_A_Log "ERROR - No se pudo determinar el n° de tlog activo." ${LOGSCRIPT}
         Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
         exit 4
fi
