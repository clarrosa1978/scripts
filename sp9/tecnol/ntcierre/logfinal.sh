#/usr/bin/ksh
set -x
################################################################################
#      Script: logfinal.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 20/05/1999
# Descripcion: Trae el log del cierre de NT de la sucursal una vez finalizado el
#		cierre de la sucursal.
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="logfinal.sh"
export HOST SCRIPT
. /tecnol/bin/suc3to2.lib
FECHA="$1" # AAAAMMDD
NSUC=$2 # XXX
SUC2=`suc3to2 "$NSUC"`
SUC="suc$SUC2"
DIA="`echo $FECHA | cut -c7-8`"
MES="`echo $FECHA | cut -c5-6`"
ANIO="`echo $FECHA | cut -c1-4`"

#DIRECTORIO DE PROCESAMIENTO
cd /tecnol/ntcierre

#Depuracion de informacion guardada anteriormente

#Obtencion de los logs de las sucursales
rcp $SUC:/tecnol/ntcierre/log/$SUC.$FECHA /tecnol/ntcierre/log/$SUC.$FECHA
rcp $SUC:/tecnol/ntcierre/log/bkp$SUC.$FECHA /tecnol/ntcierre/log/bkp$SUC.$FECHA
rcp $SUC:/tecnol/ntcierre/log/vts.log.$FECHA /tecnol/ntcierre/mail/vts.$NSUC.$FECHA
rcp $SUC:/tecnol/ntcierre/log/precios.log.$FECHA /tecnol/ntcierre/mail/precios.$NSUC.$FECHA
rcp $SUC:/tecnol/ntcierre/log/listados /tecnol/ntcierre/mail/listado.$NSUC.$FECHA
rcp $SUC:/tecnol/ntcierre/log/backup.$FECHA /tecnol/ntcierre/mail/backup.$NSUC.$FECHA
rcp $SUC:/tecnol/ntcierre/log/interfaces.$FECHA /tecnol/ntcierre/mail/interfaces.$NSUC.$FECHA

#Se coloca la marca de fin de cadena de la sucursal
touch  /tecnol/ntcierre/fin/fin$SUC2.$FECHA

#Se unifican los log en un archivo
echo "=========================================" > /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "DETALLE DEL CIERRE DE LA SUCURSAL $NSUC" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "=========================================" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "Procesamiento de la cadena (ts)" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "-------------------------------" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
if [ ! -s /tecnol/ntcierre/mail/vts.$NSUC.$FECHA ]
then
	echo "Se ejecutaron exitosamente todos los procesos" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
else
	cat /tecnol/ntcierre/mail/vts.$NSUC.$FECHA >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
fi
echo "" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "Listados de la cadena" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "----------------------" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
if [ ! -s /tecnol/ntcierre/mail/listado.$NSUC.$FECHA ]
then
	echo "Se generaron todas los listados sin problemas" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
else
	cat /tecnol/ntcierre/mail/listado.$NSUC.$FECHA >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
fi
echo "" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "Procesamiento de Precios" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "-------------------------" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
if [ ! -s /tecnol/ntcierre/mail/precios.$NSUC.$FECHA ]
then
	echo "Sin informacion del procesamiento de Precios" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
else
	cat /tecnol/ntcierre/mail/precios.$NSUC.$FECHA >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
fi
echo "" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "Procesamiento de Tickets y Facturas" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "------------------------------------" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
if [ ! -s /tecnol/ntcierre/mail/interfaces.$NSUC.$FECHA ]
then
	echo "Sin informacion del procesamiento de Tickets y Facturas" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
else
	cat /tecnol/ntcierre/mail/interfaces.$NSUC.$FECHA >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
fi
echo "" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "Backup" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "-------" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
if [ ! -s  /tecnol/ntcierre/mail/backup.$NSUC.$FECHA ]
then
	echo "Sin informacion del resultado del Backup" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
else
	cat /tecnol/ntcierre/mail/backup.$NSUC.$FECHA >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
fi
echo "" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "Transferencias" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "----------------" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
if [ ! -s  /tecnol/trntcierre/log/trasnfer$NSUC.$FECHA ]
then
	echo "La transferencia de los archivos a central se realizo sin problemas" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
else
	cat /tecnol/trntcierre/log/transfer$NSUC.$FECHA >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
fi
echo "" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
echo "" >> /tecnol/ntcierre/mail/mail.$NSUC.$FECHA
