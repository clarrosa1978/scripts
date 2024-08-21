#/usr/bin/ksh
set -x
################################################################################
#      Script: mandamail.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 20/05/1999
# Descripcion: Envia el mail con el informe de todos los cierre
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="mandamail.sh"
FECHA="$1"
export HOST SCRIPT FECHA
cd /tecnol/ntcierre
rm msg
echo "mail from: operaciones@coto.com.ar" >> msg
echo "rcpt to: maillogsuc@ecs" >> msg
echo "data" >> msg
echo "subject: Informe del Procesamiento del cierre de Sucursales" >> msg
echo 'to: Atencion a Sucursales; Tecnologia;operaciones' >> msg
for i in `cat lista3`
do
	if [ -f /tecnol/ntcierre/mail/mail.$i.$FECHA ]
	then
		cat /tecnol/ntcierre/mail/mail.$i.$FECHA >> msg
	fi
done
echo "" >> msg
echo "." >> msg
echo "quit" >> msg
telnet ecs 25 < msg
rm msg
> /tecnol/ntcierre/backup.tecnol
FECHA_AUX=$FECHA
for i in `cat lista3`
do
	. /tecnol/bin/suc3to2.lib
	SUC2=`suc3to2 "$i"`
        # /---------------------------------------------------------------------------------------------\
	#          CML - NOCTM tiene la lista de las sucursales que corren el backup por crontab.
	#          Por este motivo es necesario modificar la variable FECHA con la que se busca el
	#          resultado de la ejecucion del backup de la noche anterior.                     
	# \---------------------------------------------------------------------------------------------/
	NOCTM="73 87"
	for j in $NOCTM
	do
	  if [ "$SUC2" = "$j" ]
	   then
		FECHA=`date +%Y%m%d`	
		break
           else
		FECHA=$FECHA_AUX
	  fi
	done
       # /------- Fin de la modificacion - CML---------------------------------------------------------\

	if [ ! -f /tecnol/ntcierre/mail/backup.$i.$FECHA ]
	then
		rcp suc$SUC2:/tecnol/ntcierre/log/backup.$FECHA /tecnol/ntcierre/mail/backup.$i.$FECHA
	fi
	if [ -f /tecnol/ntcierre/mail/backup.$i.$FECHA ]
	then
		grep -v "BACKUP FINALIZO OK" /tecnol/ntcierre/mail/backup.$i.$FECHA
		STATUS="$?"
		if [ "$STATUS" -eq 0 ]
		then
			echo "SUCURSAL $i" >> /tecnol/ntcierre/backup.tecnol
			echo "------------" >> /tecnol/ntcierre/backup.tecnol
			cat /tecnol/ntcierre/mail/backup.$i.$FECHA >> /tecnol/ntcierre/backup.tecnol
			echo "\n" >> /tecnol/ntcierre/backup.tecnol
		fi	
	fi
done

echo "mail from: operaciones@coto.com.ar" >> msg
echo "rcpt to: admunix@ecs.coto.com.ar" >> msg
echo "data" >> msg
echo "subject: Detalle de Backups Finalizados con errores el dia $FECHA" >> msg
echo "to: Administracion de Sistemas;" >> msg
echo ""
cat /tecnol/ntcierre/backup.tecnol >> msg
echo "." >> msg
echo "quit" >> msg
telnet ecs 25 < msg
rm msg
rm /tecnol/ntcierre/backup.tecnol
find /tecnol/ntcierre/mail -mtime 10  -print -exec rm {} \;
find /tecnol/ntcierre/log -mtime 10 -print -exec rm {} \;
exit 0
