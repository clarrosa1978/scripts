#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: GPA                                                    #
# Grupo..............: GPA                                                    #
# Autor..............: Marcos Corvalan                                        #
# Objetivo...........: Trae de GDM desde la tabla GPA_RECETAGDM               #
# Nombre del programa: granjaNovedadRecetas.sh                                # 
# Nombre del JOB.....: granjaNovedadRecetas.sh                                #   
# Modificacion.......: 09/08/2016                                             #
###############################################################################

set -x
 
###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1} 
export NOMBRE="granjaNovedadRecetas"
export PATHAPL="/tecnol/gpa"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export BASE=/@PT01GPA
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
