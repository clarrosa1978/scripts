#!/usr/bin/ksh
#################################################################################
#                                                                               #
#                                                                               #
#  SCRIPT PARA BAJAR LOS DEMONIOS                                               #
#  DEL VERIFICADOR CENTRAL COTO (VCC)                                           #
#                                                                               #
#################################################################################
set -x

USUARIO=sfvcc
CANTIDAD=4		#Cantidad de procesos SF_* que deben estan activos

#************************************
#* LEVANTA LOS PROCESOS DE VCC      *
#************************************
/sfvcc/bin/SF_VCC
/sfvcc/bin/SF_TOS
/sfvcc/bin/SF_DCC
/sfvcc/bin/SF_CLIENTE

#CONTROL de PROCESOS ACTIVOS

CUENTA=""
CUENTA=$(ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_" | wc -l)

[ ${CUENTA} ] &&  VACIA="FALSE" || VACIA="TRUE"
if [ $VACIA != "TRUE" ] && [ $CUENTA -eq $CANTIDAD ]
then
	echo "LOS CUATRO PROCESOS de VCC estan ACTIVOS"
	ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_"
else
	echo "Atencion NO LEVANTARON LOS CUATRO PROCESOS de VCC"
	echo "/sfvcc/bin/SF_VCC, SF_TOS, SF_DCC, SF_CLIENTE"
	echo "Procesos activos..."
	ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_"
	exit 3
fi
