################################################################################
#      Script: gencond.sh
#       Autor: Gustavo Goette
#    Ult.Mod.: 12/08/1999
# Descripcion: genera condiciones para transferencias FTP
################################################################################
HOST="`hostname -s`"".coto.com.ar"
SCRIPT="gencond.sh"
APLICATION=$1
CONDITION=$2
LOG=$3
export APLICATION CONDITION LOG
clear
if [ $# -ne 3 ]
then
        echo "Usage $0 APLICATION_NAME CONDITION_NAME LOG_FILE"
        exit 14
fi

echo "1. Preparando entorno para generacion del requerimiento\n"
. /home/ctm/server/ctm/exe_AIX/ctm_env.sh
sleep 1
echo "2. Obteniendo la Fecha y Hora del Requerimiento\n"
sleep 1
DATE=`/home/ctm/server/ctm/exe_AIX/ctmstvar 0 %%OMONTH.%%ODAY`
NCDATE=`echo "$DATE" | sed s/" "//g | wc -m | sed s/" "//g`
if [ "$NCDATE" != 5 ]
then
	echo "\n\nERROR generando condicion para Trans. $APLICATION en `hostname`" > msg
	
	mail -s "Error APLICACION FTPS" operadoresUX@coto.com.ar -c hprofitos@coto.com.ar < msg
	echo "ERROR generando condicion para Trans. $APLICATION"
	echo "Comunicarse con centro de Computos"
	echo "Presione enter para Continuar"
	read conf
	rm msg
else
	echo "3. Generando requerimiento de envio\n"
	sleep 1
	/home/ctm/server/ctm/exe_AIX/ecacontb add "$CONDITION" "$DATE"
	STATUS="$?"
	if [ "$STATUS" != 0 ] 
	then
        	echo "\n\nERROR generando condicion para trans. $APLICATION `hostname`" > msg
		mail -s "Error APLICACION FTPS" operadoresUX@coto.com.ar -c hprofitos@coto.com.ar < msg
		rm msg
	else
		echo "4. Requerimiento de envio generado exitosamente\n"
		echo "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\t\t\t Presione Enter para Continuar\c"
		echo "`date +"%d/%m/%Y-%H:%M"` Requerimiento de Envio de Archivos de $APLICATION" > $LOG
		read conf
	fi
fi
exit 0
