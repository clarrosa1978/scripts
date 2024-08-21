#!/bin/ksh
###############################################################################
# Apliacion..........: BACKUP                                                 #
# Grupo..............: XXXXXXXXXXX                                            #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Realizar backup del filesystem.                        #
# Nombre del programa: bkp_fsys.sh                                            #
# Nombre del JOB.....: BKPXXXXXXXXXXXX                                        #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un backup full/incremental del filesystem.     #
# Modificacion.......: 29/06/2011                                             #
# Parametros.........: Fecha (AAAAMMDD).                                      #
#                      incremental (Backup Incremental)                       #
#                              o                                              #
#                      selective   (Backup Full)                              #
#                                                                             #
# Tipo de errores de salida :                                                 #
#                          1: Error.                                          #
###############################################################################
# PMORALES 20/07/2012:
# Se agrega la linea -virtualmountpoint=/ ( se pasa como parametro al comando )
# Debido al error expuesto abajO:

# ANS1149E No domain is available for incremental backup. The domain may be empty
# or all file systems in the domain are excluded.

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export HOST='hostname'
export FECHA=${1}
export TIPO_BACKUP=${2}
export HORA=`date +'%H:%M'`
export NOMBRE="bkp_fsys"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
export LOGSCRIPT="${PATHLOG}/${NOMBRE}.${TIPO_BACKUP}.${FECHA}.${HORA}.log"
export COMANDO="/opt/tivoli/tsm/client/ba/bin/dsmc"

###############################################################################
###                            Funciones                                    ###
###############################################################################
. /tecnol/funciones/Borrar
. /tecnol/funciones/Check_Par
. /tecnol/funciones/Enviar_A_Log

autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 $@
[ $? != 0 ] && exit 1
find ${PATHLOG} -name "${NOMBRE}.*log" -mtime +2 -exec rm {} \;
Enviar_A_Log "INICIO - Comienza la ejecucion del backup full/incremental del filesystem." ${LOGSCRIPT}
[ $? != 0 ] && exit 3
if [ -x ${COMANDO} ]
then
 sudo ${COMANDO} ${TIPO_BACKUP} > ${LOGSCRIPT}
 RESUL=$?
        if [ $RESUL != 0 ] && [ $RESUL != 4 ] && [ $RESUL != 8 ] && [ $RESUL != 12 ]; then
          Enviar_A_Log "ERROR - Fallo la ejecucion del backup de ${HOST}." ${LOGSCRIPT}
          Enviar_A_Log "FINALIZACION - CON ERROR." ${LOGSCRIPT}
          exit 1
 else
  Enviar_A_Log "FINALIZACION - OK." ${LOGSCRIPT}
  find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +2 -exec rm {} \;
   exit 0
        fi
else
        Enviar_A_Log "ERROR - No hay permisos de ejecucion para el comando ${COMANDO}." ${LOGSCRIPT}
        Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOGSCRIPT}
        exit 1
fi
