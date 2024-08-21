#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Transferir via scp el archivo liq1251 de banelco.      #
# Nombre del programa: scp_liq.sh                                             #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......:                                                        #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export EXEC_FLAG="$1"
export SOURCE_DIR="$2"
export TARGET_HOST="$3"
export TARGET_DIR="$4"
export ALTERN_DIR="NULL"
export ALTERN_FILENAME="NULL"
export RETRIES="NULL"
export RETRIES_DELAY="NULL"
export REM_USER="NULL"
export TARGET_OWNER="$5"
export TARGET_GROUP="$6"
export TARGET_MODE="$7"
export USER=transfer

for ARCH in $(cat /tmp/liq1251.tmp)
do
export SOURCE_FILENAME=$ARCH
export TARGET_FILENAME=$ARCH
done


###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 7 $@
[ $? != 0 ] && exit 1
if [ -f /tecnol/bin/safe_scp -a -x /tecnol/bin/safe_scp ]
then
        /tecnol/bin/safe_scp "$EXEC_FLAG" "$SOURCE_DIR" "$SOURCE_FILENAME" "$TARGET_HOST" "$TARGET_DIR" "$TARGET_FILENAME" "$ALTERN_DIR" "$ALTERN_FILENAME" "$RETRIES" "$RETRIES_DELAY" "$REM_USER" "$TARGET_OWNER" "$TARGET_GROUP" "$TARGET_MODE" "$USER"

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
rm /tmp/liq1251.tmp
exit "$EXIT_STAT"
