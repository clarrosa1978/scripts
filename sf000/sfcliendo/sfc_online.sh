#!/usr/bin/ksh
#################################################################################
#                                                                               #
# Script:/tecnica/sfctrl/sfc_online.sh                                          #
#                                                                               #
#  SCRIPT PARA ACTIVAR LOS DEMONIOS                                             #
#  DEL USUARIO SFCLIEND ( Tarjeta COTO BENEFICIO )                              #
#                                                                               #
#################################################################################
#set -x

USUARIO=sfcliend
CANTIDAD=1		#Cantidad de procesos SF_* que deben estan activos
DIA=${1}

#************************************
#* LEVANTA LOS PROCESOS DE VCC      *
#************************************
cd /sfcliendo/bin 
if [ $? != 0 ]
then
	echo "Error al cambiar de direcotrio"
	exit 3
fi

if [ -s /sfcliendo/tmp/sfcliendo.${DIA}.log.Z ]
then
	compress -d -f /sfcliendo/tmp/sfcliendo.${DIA}.log.Z || exit 3
else
	echo "No existe log /sfcliendo/tmp/sfcliendo.${DIA}.log.Z"
fi

./SF_CLIENDO


#CONTROL de PROCESOS ACTIVOS

CUENTA=""
CUENTA=$(ps -ef | grep ${USUARIO} | grep -v grep | grep "./SF_CLIENDO" | wc -l)

[ ${CUENTA} ] &&  VACIA="FALSE" || VACIA="TRUE"
if [ $VACIA != "TRUE" ] && [ $CUENTA -eq $CANTIDAD ]
then
	echo "El proceso SF_CLIENDO esta activo"
	ps -ef | grep ${USUARIO} | grep -v grep | grep "./SF_CLIENDO"
else
	echo "Atencion NO LEVANTO EL PROCESO ./SF_CLIENDO"
	exit 3
fi
