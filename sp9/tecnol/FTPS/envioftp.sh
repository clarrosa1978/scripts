#/usr/bin/ksh
set -x
################################################################################
#      Script: envioftp.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 12/08/1999
# Descripcion: envio de archivos FTP
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="envioftp.sh"
FECHA=`date +"%d%m.%H%M"`
TARGET_HOST="$1" #Destination HOST
COMMAND_FILE="$2" #File whith FTP commands
APLICATION="$3" # Aplication's name
LOG_FILE="$4" # log file
export HOST SCRIPT FECHA LOG_FILE

if [ $# -ne 4 ]
then
        echo "Usage $0 TARGET_HOST COMMAND_FILE APLICATION_NAME LOG_FILE"
        exit 14
fi

echo "`date +"%d/%m/%Y-%H:%M"` Comienzo de Copia de archivos de $APLICATION" >> $LOG_FILE
cd $SOURCE_DIR
/tecnol/bin/safe_ftp "$TARGET_HOST" "root" "" "$COMMAND_FILE"
STATUS="$?"
if [ "$STATUS" != 0 ]
then
	echo "`date +"%d/%m/%Y-%H:%M"` Error en la transferencia de archivos"
	exit $STATUS
else
	echo "Transferencia finalizada exitosamente"
	echo "`date +"%d/%m/%Y-%H:%M"` Finalizada la transferencia de Archivos de $APLICATION OK" >> $LOG_FILE
fi

exit 0
