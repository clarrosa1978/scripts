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
#export SOURCE_FILENAME="$3"
export TARGET_HOST="$4"
export TARGET_DIR="$5"
#export TARGET_FILENAME="$6"
export ALTERN_DIR="NULL"
export ALTERN_FILENAME="NULL"
export RETRIES="NULL"
export RETRIES_DELAY="NULL"
export REM_USER="NULL"
export TARGET_OWNER="$7"
export TARGET_GROUP="$8"
export TARGET_MODE="$9"
export USER=transfer

#-------------------------------------------------------------------------------------------------------
# ESTA PARTE SE MODIFICO PARA QUE TOME LA VARIABLE OWDAY QUE USA PARA TRAERSE EL ULTIMO ARCHIVO DEL DIA
#-------------------------------------------------------------------------------------------------------

FILE_NAME_IN=$3

SEC_CTRLM=`echo $FILE_NAME_IN | cut -d'.' -f2 | cut -c4`  #
FILESYSTEMS=`echo $FILE_NAME_IN | cut -d'.' -f1`

if [ $SEC_CTRLM = 0 ]
then
        export SEC=7
else
        export SEC="$SEC_CTRLM"
fi

export SOURCE_FILENAME="$FILESYSTEMS.sec$SEC.tar.bzip2"

#----------------------------------------------------------------------------------------------

FILE_NAME_OUT=$6

SEC_CTRLM=`echo $FILE_NAME_OUT | cut -d'.' -f2 | cut -c4`  #
FILESYSTEMS=`echo $FILE_NAME_OUT | cut -d'.' -f1`

if [ $SEC_CTRLM = 0 ]
then
        export SEC=7
else
        export SEC="$SEC_CTRLM"
fi

export TARGET_FILENAME="$FILESYSTEMS.sec$SEC.tar.bzip2"

#----------------------------------------------------------------------------------------------



###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 9 $@
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
	find "${TARGET_DIR}" -mtime +7 -exec rm {} \;

else
         echo "\n\n`date +"%d/%m/%Y"` $0: Este programa no existe o no posee permiso de ejecucion"|tee -a "$LOG_DIR"/errlog
         exit 31
fi

exit "$EXIT_STAT"
