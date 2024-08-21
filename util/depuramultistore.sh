#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: UTIL                                                   #
# Grupo..............: DATABASE                                               #
# Autor..............: GAUNA                                                  #
# Objetivo...........:                                                        #
# Nombre del programa: depuramultistore.sh                                    #
# Nombre del JOB.....: DEPURAMULTISTORE                                       #
# Solicitado por.....:                                                        #
# Descripcion........: Depuración de tablas Multistore Sucursales             #
# Solicitado por.....: Administracion DB                                      #
# Creacion...........: 13/09/2011                                             #
# Modificacion.......:                                                        #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA=${1}
export NOMBRE="depuramultistore"
export PATHAPL="/tecnol/util"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"
export DESTINATARIO="dbadmin@redcoto.com.ar"
export ASUNTO="Depuracion Tablas Multistore Sucursales - ${FECHA}"

###############################################################################
###                            Principal                                    ###
###############################################################################

autoload Check_Par
autoload Enviar_Mail_DAdjuntos
Check_Par 1 $@
[ $? != 0 ] && exit 1
autoload Enviar_A_Log
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
                                        find ${PATHLOG} -name "${NOMBRE}.*.lst" -mtime +30 -exec rm {} \;
                                        find ${PATHLOG} -name "${NOMBRE}*.log" -mtime +30 -exec rm {} \;
                                        exit 0
                                else
                                        Enviar_Mail_DAdjuntos "${DESTINATARIO}" "${ASUNTO}" "${LSTSQLGEN}"
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
