#/usr/bin/ksh
set -x
################################################################################
#      Script: traelog.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 20/05/1999
# Descripcion: Trae el log del cierre de NT de las sucursales
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="traelog.sh"
export HOST SCRIPT
FECHA="$1"
DIA="`echo $FECHA | cut -c7-8`"
MES="`echo $FECHA | cut -c5-6`"
ANIO="`echo $FECHA | cut -c1-4`"


#DIRECTORIO DE PROCESAMIENTO
cd /tecnol/ntcierre

#Depuracion de informacion guardada anteriormente
> /tecnol/ntcierre/backups
echo "$ANIO/$MES/$DIA" > /tecnol/ntcierre/cierres

#Obtencion de los logs de las sucursales
for i in `cat lista`
do
	if [ ! -f /tecnol/ntcierre/fin/fin$i.$FECHA ]
	then
		rcp suc$i:/tecnol/ntcierre/log/suc$i.$FECHA /tecnol/ntcierre/log/suc$i.$FECHA
		rcp suc$i:/tecnol/ntcierre/log/bkpsuc$i.$FECHA /tecnol/ntcierre/log/bkpsuc$i.$FECHA
		rcp suc$i:/tecnol/ntcierre/mail/backup.$i.$FECHA /tecnol/ntcierre/log/backup.$i.$FECHA
	fi
done
#Se coloca la marca de fin de linea en las sucursales que no la tengan
for i in `cat lista`
do
	if [ -f /tecnol/ntcierre/log/suc$i.$FECHA ]
	then
		LINEAS=`wc -l /tecnol/ntcierre/log/suc$i.$FECHA | awk ' { print $1 }' `
		if [ $LINEAS = 0 ] 
		then 
			echo " " >> /tecnol/ntcierre/log/suc$i.$FECHA
		fi 
	fi
	if [ -f /tecnol/ntcierre/log/bkpsuc$i.$FECHA ]
	then
		LINEAS=`wc -l /tecnol/ntcierre/log/bkpsuc$i.$FECHA | awk ' { print $1 }' `
		if [ $LINEAS = 0 ] 
		then 
			echo " " >> /tecnol/ntcierre/log/bkpsuc$i.$FECHA
		fi 
	fi
done
#Se unfican los log en un archivo
for i in `cat lista`
do
	if [ -f /tecnol/ntcierre/log/suc$i.$FECHA ]
	then
		cat /tecnol/ntcierre/log/suc$i.$FECHA >> /tecnol/ntcierre/cierres
	fi
	if [ -f /tecnol/ntcierre/log/bkpsuc$i.$FECHA ]
	then
		cat /tecnol/ntcierre/log/bkpsuc$i.$FECHA >> /tecnol/ntcierre/backups
	fi
done

cp /tecnol/ntcierre/cierres /tecnol/ntcierre/planilla/cierres."$FECHA"
cp /tecnol/ntcierre/backups /tecnol/ntcierre/planilla/backups."$FECHA"

#Copia de archivos a la PC de operaciones  
ftp -v pcop2 < /tecnol/ntcierre/ftp.cmd
ftp -v pcgoren < /tecnol/ntcierre/ftpgoren.cmd
