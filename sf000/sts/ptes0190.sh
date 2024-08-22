#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: INTERFACE-CTC-STS                                      #
# Grupo..............: LD-CTC-STS                                             #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Carga interfase de cobranzas,facturas y pagos.         #
# Nombre del programa: ptes0190.sh                                            #
# Nombre del JOB.....: PTES0190                                               #
# Descripcion........:                                                        #
# Modificacion.......: 27/11/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################

export FECHA="${1}"
export SUCURSAL="${2}"
export NOMBRE="ptes0190"
export USUARIO="/"
export PATHAPL="/tecnol/sts"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"

###############################################################################
###                            Funciones                                    ###
###############################################################################

autoload Enviar_A_Log
autoload Borrar
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################

Check_Par 2 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
Borrar ${LSTSQLGEN}
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
                sqlplus ${USUARIO} @${SQLGEN} ${SUCURSAL} ${LSTSQLGEN}
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