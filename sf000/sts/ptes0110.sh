#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: STS                                                    #
# Grupo..............: GEN-INTERFASE-STS-PS                                   #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Genera interfaces de movimientos y cierres de caja.    #
# Nombre del programa: ptes0110.sh                                            #
# Nombre del JOB.....: PTES0110                                               #
# Descripcion........:                                                        #
# Modificacion.......: 26/08/2005                                             #
###############################################################################
set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
 
autoload Check_Par
Check_Par 2 $@
[ $? != 0 ] && exit 1
 
export SUC=${1}
export FECHA=${2}
export PATHAPL="/tecnol/sts"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export NOMBRE="ptes0110"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.lst"
export USUARIO="/"
export SQLGEN="${PATHSQL}/${NOMBRE}.sql"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Enviar_A_Log
autoload Borrar
 
 
###############################################################################
###                            Principal                                    ###
###############################################################################
 
Enviar_A_Log "INICIO - Comienza la ejecucion." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
cd ${PATHAPL}
[ $? != 0 ] && exit 2
Borrar ${LSTSQLGEN}
if [ -x $ORACLE_HOME/bin/sqlplus ]
then
        if [ -r ${SQLGEN} ]
        then
                sqlplus ${USUARIO} @${SQLGEN} ${SUC} ${FECHA} ${LSTSQLGEN}
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
