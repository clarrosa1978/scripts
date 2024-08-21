#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realizar backup mensuales con rman a cinta.            #
# Nombre del programa: bkp_tape_mens.sh  		                      #
# Nombre del JOB.....: XXXXXXXXXX                                             #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup full de la BD                        #
# Creacion...........: 13/04/2010                                             #
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
export NOMBRE="bkp_tape_mens"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export RMAN="${PATHAPL}/bkp_tape_mens.rmn"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export LOGRMAN="${PATHLOG}/${NOMBRE}.${ORACLE_SID}.${FECHA}.rman.log"

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
Enviar_A_Log "INICIO - Comienza la ejecucion del backup full ${ORACLE_SID}." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x /u01/app/oracle/product/928/bin/rman ]
then
        if [ -r ${RMAN} ]
        then
                $ORACLE_HOME/bin/rman target / nocatalog @${RMAN} log=${LOGRMAN}
		RESUL=$?
                if [ $RESUL != 0 ]
                then
                   Enviar_A_Log "ERROR - Fallo la ejecucion del backup level ${TIPOBK} de ${ORACLE_SID}." ${LOGSCRIPT}
                   Enviar_A_Log "FINALIZACION - CON ERROR ($RESUL)." ${LOGSCRIPT}
                   exit $RESUL
		else
                   Enviar_A_Log "FINALIZACION - BACKUP OK ${ORACLE_SID}." ${LOGSCRIPT}
                   find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +365 -exec rm {} \;
                   exit 0
                fi
        else
                Enviar_A_Log "ERROR - No hay permisos de lectura para archivo ${RMAN}." ${LOGSCRIPT}
                Enviar_A_Log "FINALIZACION - CON ERRORES BACKUP ${ORACLE_SID}." ${LOGSCRIPT}
                exit 77
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando rman." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES BACKUP ${ORACLE_SID}." ${LOGSCRIPT}
        exit 88
fi
