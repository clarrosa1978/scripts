#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: GDM                                                    #
# Grupo..............: GDM                                                    #
# Autor..............: Hugo Cerizola                                          #
# Objetivo...........:                                                        #
# Nombre del programa: RevisaDifVenta                                         #
# Nombre del JOB.....: REVDIFVTA                                              #
# Solicitado por.....: Claudio Polo                                           #
# Descripcion........: Control de Venta Entre Multistore y GDM                #
# Modificacion.......: 06/11/2012                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="RevisaDifVenta"
export PATHAPL="/tecnol/gdm"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"
export DESTINATARIO="soportestoreflow@redcoto.com.ar,SoportedeAplicaciones@redcoto.com.ar"
export ASUNTO="Control de Venta Entre Multistore y GDM - $FECHA"

###############################################################################
###                            Funciones                                    ###
###############################################################################

autoload Borrar
autoload Enviar_Mail
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

					cat ${LSTSQLGEN} | mhmail ${DESTINATARIO} -subject "${ASUNTO}"
                                        find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +7 -exec rm {} \;
                                        find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
                                        exit 0
                                else
                                        Enviar_A_Log "ERROR - Error de Oracle durante la ejecucion." ${LOGSCRIPT}
                                        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
					cat ${LSTSQLGEN} | mhmail ${DESTINATARIO} -subject "${ASUNTO}"
                                        exit 7
                                fi
                        else
                                Enviar_A_Log "ERROR - No se genero el archivo de spool." ${LOGSCRIPT}
                                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                                exit 9
                        fi
                fi

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
