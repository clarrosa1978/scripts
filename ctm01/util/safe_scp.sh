#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Transferir via scp un archivo.                         #
# Nombre del programa: safe_scp.sh                                            #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 24/05/2006                                             #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export EXEC_FLAG="$1"
export SOURCE_DIR="$2"
export SOURCE_FILENAME="$3"
export TARGET_HOST="$4"
export TARGET_DIR="$5"
export TARGET_FILENAME="$6"
export ALTERN_DIR="NULL"
export ALTERN_FILENAME="NULL"
export RETRIES="NULL"
export RETRIES_DELAY="NULL"
export REM_USER="NULL"
export TARGET_OWNER="$7"
export TARGET_GROUP="$8"
export TARGET_MODE="$9"

###############################################################################
###                            Funciones                                    ###
###############################################################################
. /tecnol/funciones/Check_Par
. /tecnol/funciones/Enviar_A_Log

autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 9 $@
[ $? != 0 ] && exit 1
if [ -f /tecnol/util/safe_scp -a -x /tecnol/util/safe_scp ]
then
         /tecnol/util/safe_scp "$EXEC_FLAG" "$SOURCE_DIR" "$SOURCE_FILENAME" "$TARGET_HOST" "$TARGET_DIR" "$TARGET_FILENAME" "$ALTERN_DIR" "$ALTERN_FILENAME" "$RETRIES" "$RETRIES_DELAY" "$REM_USER" "$TARGET_OWNER" "$TARGET_GROUP" "$TARGET_MODE"

         EXIT_STAT="$?"

         if [ "$EXIT_STAT" -ne 0 ]
         then
                  echo "\n\n$0: LOs errores de cancelacion del prog. safe_scp, hay que"
                  echo "buscarlos en el log /tmp/errlog"
         fi

else
         echo "\n\n`date +"%d/%m/%Y"` $0: Este programa no existe o no posee permiso de ejecucion"|tee -a "$LOG_DIR"/errlog
         exit 31
fi

exit "$EXIT_STAT"
