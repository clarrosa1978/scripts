#/usr/bin/ksh
set -x
################################################################################
#      Script: envioCAP.ah
#       Autor: Gustavo Goette
#    Ult.Mod.: 06/07/1999
# Descripcion: envia los archivos al GAIA para el sistema Automatico de Prov.
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="envioCAP.sh"
FECHA=`date +"%d%m.%H%M"`
LOG=/tecnol/CAP/CAP2.log
export HOST SCRIPT FECHA LOG

cd /tecnol/CAP

#Depuracion de archivos anteriores
if [ -f /tecnol/CAP/CAP.zip ]
then
	rm /tecnol/CAP/CAP.zip
fi

if [ -f /tecnol/CAP/DETALLES.DAT ]
then
	rm /tecnol/CAP/DETALLES.DAT
fi

if [ -f /tecnol/CAP/PAGOS.DAT ]
then
	rm /tecnol/CAP/PAGOS.DAT
fi

if [ -f /tecnol/CAP/PROV.DAT ]
then
	rm /tecnol/CAP/PROV.DAT
fi

echo "`date +"%d/%m/%Y-%H:%M"` Comienzo de Copia de archivosde DATOS al sistema CAP" > $LOG
/tecnol/bin/safe_rcp G /tecnica/CAP CAP.zip amscentral /tecnol/CAP CAP.zip "NULL" "NULL" 3 300 "NULL" root system 600
STATUS="$?"
if [ "$STATUS" != 0 ]
then
	echo "Error al copiar los archivos al sp9"
	exit $STATUS
fi

cp /tecnol/CAP/CAP.zip /FTPS/CAP/CAP.zip.$FECHA


/tecnol/bin/unzip -d -o /tecnol/CAP/CAP.zip

/tecnol/bin/safe_ftp CAP_ftp_site "NULL" "NULL" /tecnol/CAP/ftpCAP.cmd
STATUS="$?"
if [ "$STATUS" != 0 ]
then
	echo "Error en la transferencia de archivos"
	exit $STATUS
else
	touch /tecnol/CAP/TESTIGO.DAT
	/tecnol/bin/safe_ftp CAP_ftp_site "NULL" "NULL" /tecnol/CAP/finftpCAP.cmd
	STATUS="$?"
	if [ "$STATUS" != 0 ]
	then 
		echo "Error poniendo marca de fin de transferencia"
		exit "$STATUS"
	else 
		echo "Transferencia finalizada exitosamente"
		echo "`date +"%d/%m/%Y-%H:%M"` Finalizada la transferencia de Archivos de DATOS al sistema CAP OK" >> $LOG
	fi	
fi

if [ -f /tecnol/CAP/CAP.zip ]
then
        rm /tecnol/CAP/CAP.zip
fi

if [ -f /tecnol/CAP/DETALLES.DAT ]
then
        rm /tecnol/CAP/DETALLES.DAT
fi

if [ -f /tecnol/CAP/PAGOS.DAT ]
then
        rm /tecnol/CAP/PAGOS.DAT
fi

if [ -f /tecnol/CAP/PROV.DAT ]
then
        rm /tecnol/CAP/PROV.DAT
fi

exit 0
