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
CANTIDAD=5		#Cantidad de procesos SF_* que deben estan activos
DIA=${1}

#Chequeo log
for archivo in tos vcc dcc sfcliente
do
        if [ -s /sfvcc/tmp/${archivo}.${DIA}.log.Z ]
        then
                compress -d -f /sfvcc/tmp/${archivo}.${DIA}.log || exit 3
        fi
done


#************************************
#* LEVANTA LOS PROCESOS DE VCC      *
#************************************
/sfvcc/bin/SF_VCC
/sfvcc/bin/SF_TOS
/sfvcc/bin/SF_DCC
/sfvcc/bin/SF_CLIENTE
/sfvcc/bin/SF_PUNTOS
#/sfvcc/bin/SF_MILLAS

#CONTROL de PROCESOS ACTIVOS

CUENTA=""
CUENTA=$(ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_" | wc -l)

[ ${CUENTA} ] &&  VACIA="FALSE" || VACIA="TRUE"
if [ $VACIA != "TRUE" ] && [ $CUENTA -eq $CANTIDAD ]
then
	echo "LOS ${CANTIDAD} PROCESOS de VCC estan ACTIVOS"
	ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_"
else
	echo "Atencion NO LEVANTARON LOS ${CANTIDAD} PROCESOS de VCC"
	echo "SF_VCC, SF_TOS, SF_DCC, SF_CLIENTE, SF_PUNTOS, SF_MILLAS"
	echo "Procesos activos..."
	ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_"
	exit 3
fi