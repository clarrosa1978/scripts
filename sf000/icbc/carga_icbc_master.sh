#!/usr/bin/ksh
###############################################################################
# Nombre del JOB.....: CICBCMASTER                                            #
# Aplicacion.........: TARJETAS                                               #
# Grupo..............: ICBC  						      #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Carga archivo COTO_PAYROLL_MASTER_CREDITO              #
# Nombre del programa: carga_icbc_master.sh                                   #
# Solicitado por.....: Jose Chariano                                          #
# Descripcion........:                                                        #
# Creacion...........: 27/09/2019                                             #
# Modificacion.......: DD/MM/AAAA                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="carga_icbc_master"
export PATHAPL="/tecnol/icbc"
export PATHSQL="${PATHAPL}/sql"
export PATHLOG="${PATHAPL}/log"
export PATHARCH="/icbc"
export ARCHDATA="${PATHARCH}/COTO_PAYROLL_MASTER_CREDITO${FECHA}.txt"
export DSC="${PATHARCH}/${NOMBRE}.${FECHA}.dsc"
export BAD="${PATHARCH}/${NOMBRE}.${FECHA}.bad"
export USUARIO="/"
export CTL="${PATHSQL}/${NOMBRE}.ctl"
export LSTSQLGEN="${PATHLOG}/${NOMBRE}.${FECHA}.lst"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"

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
                sqlldr ${USUARIO} DATA=${ARCHDATA}, CONTROL=${CTL}, LOG=${LSTSQLGEN}, ROWS=10000, SKIP=0, ERRORS=9999999, BAD=${BAD}, DISCARD=${DSC}
                if [ $? != 0 ]
                then
                        Enviar_A_Log "ERROR - Fallo la ejecucion del sqlldr." ${LOGSCRIPT}
			grep 'ORA-' ${LSTSQLGEN}
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
                Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${CTL}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 77
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando sqlplus." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
