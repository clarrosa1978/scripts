#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Transferir via scp un archivo y lo descomprimo.        #
# Nombre del programa: safe_scp_rdigi.sh                                      #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 20/09/2019                                             #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export SOURCE_DIR="$1"
export SOURCE_FILENAME="$2"
export TARGET_HOST="$3"
export TARGET_DIR="$4"
export TARGET_FILENAME="$5"
export ALTERN_DIR="NULL"
export ALTERN_FILENAME="NULL"
export RETRIES="NULL"
export RETRIES_DELAY="NULL"
export REM_USER="NULL"
export TARGET_OWNER="$6"
export TARGET_GROUP="$7"
export TARGET_MODE="$8"
export TARFILENAME="$9"
export USER=transfer


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
         /tecnol/bin/safe_scp "G" "$SOURCE_DIR" "$SOURCE_FILENAME" "$TARGET_HOST" "$TARGET_DIR" "$TARGET_FILENAME" "$ALTERN_DIR" "$ALTERN_FILENAME" "$RETRIES" "$RETRIES_DELAY" "$REM_USER" "$TARGET_OWNER" "$TARGET_GROUP" "$TARGET_MODE" "$USER"

         EXIT_STAT="$?"

         if [ "$EXIT_STAT" -ne 0 ]
         then
                  echo "\n\n$0: LOs errores de cancelacion del prog. safe_scp, hay que"
                  echo "buscarlos en el log /tmp/errlog"
	 else
		  echo "Descomprimo los archivos de rollos en el directorio ${TARGET_DIR}."
		  cd $TARGET_DIR ; gunzip $TARGET_FILENAME ; tar -xvf $TARFILENAME 
		  if [ "$?" -eq 0 ]
		  then
			echo "Se pudo descomprimir bien el archivo $TARGET_FILENAME."
			rm -f $TARGET_DIR/$TARFILENAME
			exit 0
		  else
			echo "No se pudo descomprimir el archivo $TARGET_FILENAME. Verificar!!!."
			exit 2
		  fi
         fi

else
         echo "\n\n`date +"%d/%m/%Y"` $0: Este programa no existe o no posee permiso de ejecucion"|tee -a "$LOG_DIR"/errlog
         exit 31
fi
exit "$EXIT_STAT"
