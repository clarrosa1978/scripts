#!/usr/bin/ksh
################################################################################
#      Script: mailCAP.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 06/07/1999
# Descripcion: Envia confirmacion y detalle del procesamiento de archivos CAP
################################################################################
set -x

DIRCAP=/tecnol/CAP
MSG=$DIRCAP/CAP.msg
LOG=$DIRCAP/CAP2.log

echo "`date +"%d/%m/%Y-%H:%M"` Transferencia de Archivos de DATOS al sistema CAP OK" > $LOG

find /FTPS/CAP -mtime +30 -print -exec rm {} \;

#Copia del log del J-30
/tecnol/bin/safe_rcp G /tecnica/CAP CAP1.log amscentral $DIRCAP CAP1.log "NULL" "NULL" 1 1 "NULL" root system 600
if [ "$?" != 0 ]
then
	echo "Hubo un error en la copia del log del J-30"
	exit $3
fi

#Preparacion del archivo de Mail

cat $DIRCAP/CAP1.log > $MSG
echo "\n" >> $MSG
cat $DIRCAP/CAP2.log >> $MSG
echo "\n" >> $MSG

mail -s "Detalle del Procesamiento de Archivos del C.A.P" MailCAP@coto.com.ar < $MSG
