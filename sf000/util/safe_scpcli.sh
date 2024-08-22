#!/usr/bin/ksh
export PATHLOG="/tecnol/clientes/log"
export FECHA=${1}
export EXEC_FLAG=${2}
export SOURCE_DIR=${3}
export SOURCE_FILENAME="${4}"
export TARGET_HOST="${5}"
export TARGET_DIR=${6}
export TARGET_FILENAME="${7}"
export TARGET_OWNER=sfctrl
export TARGET_GROUP=sfsw
export TARGET_MODE=644
export ALTERN_DIR="NULL"
export ALTERN_FILENAME="NULL"
export RETRIES="NULL"
export RETRIES_DELAY="NULL"
export REM_USER="NULL"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 7 $@
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
