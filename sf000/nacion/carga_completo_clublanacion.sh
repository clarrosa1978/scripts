#!/usr/bin/ksh
###############################################################################
# Nombre del JOB.....: CNACION                                                #
# Aplicacion.........: TARJETAS                                               #
# Grupo..............: NACION                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Carga archivo AAAAMM_Base_de_Credenciales_COTO.dat     #
# Nombre del programa: carga_completo_nacion.sh                               #
# Solicitado por.....: Jose Chariano                                          #
# Descripcion........:                                                        #
# Creacion...........: 07/09/2016                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="carga_completo_nacion"
export PATHAPL="/tecnol/nacion"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export PATHARCH="/nacion"
export ARCHDATA="${PATHARCH}/tarjnacion_completo_${FECHA}.txt"
export DSC="${PATHARCH}/${NOMBRE}.${FECHA}.dsc"
export BAD="${PATHARCH}/${NOMBRE}.${FECHA}.bad"
export USUARIO="/"
export CTL="${PATHSQL}/${NOMBRE}.ctl"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export NOERROR=NOK

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
if [ -x $ORACLE_HOME/bin/sqlldr ]
then
        if [ -r ${CTL} ] && [ -r ${ARCHDATA} ]
        then
		if [ -s ${ARCHDATA} ]
		then
                	sqlldr ${USUARIO} DATA=${ARCHDATA}, CONTROL=${CTL}, LOG=${LSTSQLGEN}, ROWS=10000, SKIP=0, ERRORS=9999999, BAD=${BAD}, DISCARD=${DSC}
			if [ -f ${LSTSQLGEN} ]
                	then
                		grep 'ORA-00001' ${LSTSQLGEN}
				if [ $? = 0 ]
				then
					NOERROR=OK
				else
					grep 'ORA-' ${LSTSQLGEN}
					if [ $? = 0 ]
					then
						NOERROR=NOK
					else
						NOERROR=OK
					fi
				fi
                        	if [ $NOERROR = OK ]  
                        	then
                        		Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                                	find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +30 -exec rm {} \;
                                	find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +30 -exec rm {} \;
					find ${PATHARCH} -name "*.gz" -mtime +30 -exec rm {} \;
					gzip -f ${PATHARCH}/tarjnacion_completo_*.txt
					gzip -f ${PATHARCH}/*.bad
                                	exit 0
				else
					cat ${LSTSQLGEN}
                                	Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
                                	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                	exit 7	
                        	fi
			else
                		Enviar_A_Log "ERROR - No se genero el archivo de spool." ${LOGSCRIPT}
                        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                        	exit 9
                	fi
		else
			    Enviar_A_Log "ERROR - El archivo ${ARCHDATA} no tiene datos." ${LOGSCRIPT}
                            Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                            exit 9
		fi
        else
                Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${CTL}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 77
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando sqlplus." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
