#!/usr/bin/ksh
###############################################################################
# Grupo..............: BACKUP                                                 #
# Autor..............: Marcos Pablo Russo                                     #
# Objetivo...........: Realizar un expor de la base de datos SFC.             #
# Nombre del programa: export_sfc.sh                                          #
# Nombre del JOB.....: EXPORTSFC                                              #
# Solicitado por.....:                                                        #
# Descripcion........: Realiza un export de la base de datos SFC.             #
# Modificacion.......: DD/MM/AAAA                                             #
#                                                                             #
# Tipo de errores de salida :                                                 #
#                          1 : Error.                                         #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA=${1}
export NOMBRE="export_sfc"
export PATHAPL="/tecnol/backups"
export PATHLOG="${PATHAPL}/log"
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
Enviar_A_Log "INICIO - Comienza la ejecucion del backup full." ${LOGSCRIPT}
[ $? != 0 ] && exit 3

exp userid=\'/ as sysdba\' file=/expora/exp_full_${FECHA}.dmp log=${LOGSCRIPT} full=yes consistent=yes statistics=none buffer=16000000
RESUL=$?
if [ $RESUL != 0 ]
then
  Enviar_A_Log "ERROR - Fallo la ejecucion del export SFC." ${LOGSCRIPT}
  Enviar_A_Log "FINALIZACION - CON ERROR ERRORES." ${LOGSCRIPT}
  exit 1
else
  Enviar_A_Log "FINALIZACION - CORRECTAMENTE." ${LOGSCRIPT}
  find ${PATHLOG} -name "${NOMBRE}.*.log" -mtime +7 -exec rm {} \;
  find /expora    -name "exp_full_${FECHA}.dmp" -mtime +7 -exec rm {} \;
  compress /expora/exp_full_${FECHA}.dmp
  exit 0 
fi
