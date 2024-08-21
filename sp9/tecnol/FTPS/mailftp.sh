#/usr/bin/ksh
set -x
################################################################################
#      Script: mailftp.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 12/08/1999
# Descripcion: Envia confirmacion y detalle de transferencias FTP
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="mailftp.sh"
DESTACOUNT="$1" # mail account
DESTINATION="$2" #Alias for accounts
LOG="$3" #Aplication Log to send
APLICATION="$4" #Aplication's Name
MSG="$LOG.tmp" # Temp file
export HOST SCRIPT DESTACOUNT DESTINATION LOG APLICATION MSG

if [ $# -ne 4 ]
then
        echo "Usage $0 MAIL_ACOUNT ALIAS LOG_FILE APLICATION_NAME"
        exit 14
fi


#Preparacion del archivo de Mail

cat $LOG > $MSG

mail -s "Detalle del envio de Archivos de $APLICATION" MailTarjetas@coto.com.ar < $MSG

rm $MSG
exit 0
