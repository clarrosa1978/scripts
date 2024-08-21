#/usr/bin/ksh
set -x
################################################################################
#      Script: mailCAP.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 06/07/1999
# Descripcion: Envia confirmacion y detalle del procesamiento de archivos CAP
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="mailCAP.sh"
MSG=/tecnol/CAP/CAP.msg
export HOST SCRIPT

find /FTPS/CAP -mtime +30 -print -exec rm {} \;

#Copia del log del J-30
/tecnol/bin/safe_rcp G /tecnica/CAP/log CAP1.log amscentral /tecnol/CAP CAP1.log "NULL" "NULL" 3 300 "NULL" root system 600
STATUS="$?"
if [ "$STATUS" != 0 ]
then
	echo "Hubo un error en la copia del log del J-30"
	exit $STATUS
fi

#Preparacion del archivo de Mail

echo "" > $MSG
cat /tecnol/CAP/CAP1.log /tecnol/CAP/CAP2.log >> $MSG

mail -s "Detalle del Procesamiento de Archivos del C.A.P" MailCAP@coto.com.ar < $MSG
