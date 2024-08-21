#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PORTAL-DOCUMENTOS                                      #
# Grupo..............: USUARIOS                                               #
# Autor..............: Pablo Fernandez                                        #
# Objetivo...........: Actualiza tablas de usuarios, gerencias y UOs.         #
# Nombre del programa: actpddemaestros.sh                                     # 
# Nombre del JOB.....: ACTPDDEMAESTROS                                        #   
# Modificacion.......: 03/08/2023                                             #
###############################################################################

set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1} 
export NOMBRE="actpddemaestros"
export PATHAPL="/tecnol/pdde"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export BASE="USR_PDDE/tf_D853_EPSB@PT06DOC"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"
 
###############################################################################
###                            Funciones                                    ###
###############################################################################

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
                sqlplus ${BASE} @${SQLGEN} ${LSTSQLGEN} 
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
                                        find ${PATHLOG} -name "${NOMBRE}_*.log" -mtime +30 -exec rm {} \;
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
