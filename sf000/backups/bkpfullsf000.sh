#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Marcos Pablo Russo                                     #
# Objetivo...........: Realizar backup de la base de datos gdm a cinta.       #
# Nombre del programa: bkpfullsf000_tape.sh                                   #
# Nombre del JOB.....: BKPFULLGDM                                             #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup full de la base de datos dwh         #
#                      utilizando ambas librerias. Con la entrada del archivo #
#                      bkpfullsf000_tape.rmn.				      #
# Modificacion.......: DD/MM/AAAA                                             #
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
export HORA=`date +'%H:%M'`
export NOMBRE="bkpfullsf000_tape"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export RMAN="${PATHAPL}/bkpfullsf000_tape.rmn"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${FECHA}.${HORA}.log"
export LOGRMAN="${PATHLOG}/${NOMBRE}.${FECHA}.${HORA}.rman.log"

###############################################################################
###                            Funciones                                    ###
###############################################################################
#autoload Borrar
#autoload Check_Par
#autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
#Check_Par 1 $@
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
