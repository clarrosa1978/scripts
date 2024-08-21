#!/bin/bash

#################################################################
# Sincroniza el contenido de /sfctrl/i en cada caja
# Hugo O. Messina  - 21/8/2012
#################################################################

# Lee la lista de ips de las cajas del archivo ip_cajas.txt

RECURSO="imagenes"
RESULTADO=0
ERRORES='' 
#MAIL='SoporteStoreflow@redcoto.com.ar'
MAIL='cflarrosa@redcoto.com.ar'
RUTA="/tecnol/util"
ARCH="/tecnol/util/ip_cajas.txt"
ARCHLOG="$RUTA/log/rsyncd-cajas`date +%Y%m%d`.log"
ARCHERR="/tmp/rsyncd.err"

for LINEA in $(cat $ARCH)
do
	CAJA=$(echo $LINEA | cut -d':' -f 1)
	IP=$(echo $LINEA | cut -d':' -f 2)
	echo "$CAJA - $(date) - Comienza copia"
	echo "$CAJA - $(date) - Comienza copia" >> $ARCHLOG
	rsync -av /sfctrl/i/ rsync://$IP/$RECURSO/ 2>$ARCHERR
	if [ $? -ne 0 ]
	then
		RESULTADO=-1
		ERRORES=$ERRORES\ $CAJA
		cat $ARCHERR
		cat $ARCHERR >> $ARCHLOG
	else
		echo "$CAJA - $(date) - Copia OK"
		echo "$CAJA - $(date) - Copia OK" >> $ARCHLOG
	fi
	echo -e "--------------------\n"
done

if [ $RESULTADO -ne 0 ]
then
	echo "Finalizo con errores en caja(s): $ERRORES"
	echo "Finalizo con errores en caja(s): $ERRORES" >> $ARCHLOG
	#envia mail con los errores
	cat $ARCHLOG | mailx -s "rsyncd-cajas `hostname`" $MAIL
	exit 0
else
	echo "Finalizo OK"
	echo "Finalizo OK" >> $ARCHLOG
fi
echo >> $ARCHLOG
