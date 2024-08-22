#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Marcos Pablo Russo                                     #
# Objetivo...........: Realizar backup de la base de datos CTC a disco.       #
# Nombre del programa: bkpfull_disk.sh                                        #
# Nombre del JOB.....:                                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup full de la base de datos CTC         #
#                      Con la entrada del archivo bkpfull_disk.rmn.           #
# Modificacion.......: DD/MM/AAAA                                             #
# Tipo de errores de salida :                                                 #
#                          4 y 8 : Warning.                                   #
#                             12 : Critico.                                   #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export ORACLE_SID=${2}
export TIPOBK=${3}
export NOMBRE="bkp${TIPOBK}_disk"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export RMAN="${PATHAPL}/bkp${TIPOBK}_disk.${ORACLE_SID}.rmn"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.${ORACLE_SID}.log"
export LOGRMAN="${PATHLOG}/${NOMBRE}.${FECHA}.${ORACLE_SID}.rman.log"
export PATHRMAN="/backup"
export FPATH="/tecnol/funciones"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 3 $@
[ $? != 0 ] && exit 1
find ${PATHLOG} -name "${NOMBRE}.*.${ORACLE_SID}.log" -mtime +2 -exec rm {} \;
rm -f ${PATHRMAN}/cf* ${PATHRMAN}/al* ${PATHRMAN}/df* ${PATHRMAN}/sp*
Enviar_A_Log "INICIO - Comienza la ejecucion del backup full." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x ${ORACLE_HOME}/bin/rman ]
then
        if [ -r ${RMAN} ]
        then
                $ORACLE_HOME/bin/rman target / nocatalog @${RMAN} log=${LOGRMAN}
                RESUL=$?
                if [ $RESUL != 0 ]
                then
                        if [ $RESUL = 4  ]; then
                          Enviar_A_Log "ERROR - Fallo la ejecucion del backup full." ${LOGSCRIPT}
                          Enviar_A_Log "FINALIZACION - CON ERROR WARNING (4)." ${LOGSCRIPT}
                          exit 4
                        fi
                        if [ $RESUL = 8 ]; then
                          Enviar_A_Log "ERROR - Fallo la ejecucion del backup full." ${LOGSCRIPT}
                          Enviar_A_Log "FINALIZACION - CON ERROR WARNING (8)." ${LOGSCRIPT}
                          exit 8
                        fi
                        if [ $RESUL = 12 ]; then
                          Enviar_A_Log "ERROR - Fallo la ejecucion del backup full." ${LOGSCRIPT}
                          Enviar_A_Log "FINALIZACION - CON ERROR CRITICO (12)." ${LOGSCRIPT}
                          exit 12
                        fi
                else
                        Enviar_A_Log "OK - Termino bien el backup full." ${LOGSCRIPT}
                        Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                        exit 0
                fi
        else
                Enviar_A_Log "ERROR - No hay permisos de lectura para el archivo ${RMAN}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
                exit 77
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando rman." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 88
fi
