#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Marcos Pablo Russo                                     #
# Objetivo...........: Realizar backup de la base de datos sf000 a cinta.     #
# Nombre del programa: bkpfull_tape.sh                                        #
# Nombre del JOB.....: BKPFULLSF000                                           #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup full de la base de datos sf000       #
#                      utilizando ambas librerias. Con la entrada del archivo #
#                      bkpfull_tape.rmn.				      #
# Modificacion.......: DD/MM/AAAA                                             #
#                    : ORACLE_SID                                             #
#                                                                             #
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
export HORA=`date +'%H:%M'`
export NOMBRE="bkpfull_tape"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export RMAN="${PATHAPL}/bkpfull_tape.rmn"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.${HORA}.log"
export LOGRMAN="${PATHLOG}/${NOMBRE}.${FECHA}.${HORA}.rman.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 $@
[ $? != 0 ] && exit 1
  find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +2 -exec rm {} \;
Enviar_A_Log "INICIO - Comienza la ejecucion del backup full." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x /u01/app/oracle/product/928/bin/rman ]
then
        if [ -r ${RMAN} ]
        then
                $ORACLE_HOME/bin/rman target / nocatalog @${RMAN} log=${LOGRMAN}

                RESUL=$?
                if [ $RESUL != 0 ]
                then
                   Enviar_A_Log "ERROR - Fallo la ejecucion del backup full." ${LOGSCRIPT}
                   Enviar_A_Log "FINALIZACION - CON ERROR ($RESUL)." ${LOGSCRIPT}
                   exit $RESUL
                else
                   Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
                   find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +2 -exec rm {} \;
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
