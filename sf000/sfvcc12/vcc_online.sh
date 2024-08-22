#!/usr/bin/ksh
#################################################################################
#                                                                               #
#                                                                               #
#  SCRIPT PARA SUBIR LOS DEMONIOS                                               #
#  DEL VERIFICADOR CENTRAL COTO (VCC)                                           #
#                                                                               #
#################################################################################
set -x

USUARIO=sfvcc12
CANTIDAD=5		#Cantidad de procesos SF_* que deben estan activos
DIA=${1}

#Chequeo log
#ffor archivo in tos vcc dcc sfcliente
#do
#        if [ -s /sfvcc/tmp/${archivo}.${DIA}.log.Z ]
#        then
#                compress -d -f /sfvcc/tmp/${archivo}.${DIA}.log || exit 3
#        fi
#done


#************************************
#* LEVANTA LOS PROCESOS DE VCC      *
#************************************
/sfvcc12/bin/SF_ANSES
/sfvcc12/bin/SF_DNI
/sfvcc12/bin/SF_MPAGO
/sfvcc12/bin/SF_CLNACION
/sfvcc12/bin/SF_RAPPI

#CONTROL de PROCESOS ACTIVOS

CUENTA=""
CUENTA=$(ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc12/bin/SF_" | wc -l)

[ ${CUENTA} ] &&  VACIA="FALSE" || VACIA="TRUE"
if [ $VACIA != "TRUE" ] && [ $CUENTA -eq $CANTIDAD ]
then
	echo "LOS ${CANTIDAD} PROCESOS de VCC estan ACTIVOS"
	ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc12/bin/SF_"
else
	echo "Atencion NO LEVANTARON LOS ${CANTIDAD} PROCESOS de VCC"
	echo "SF_ANSES, SF_DNI, SF_MPAGO, SF_CLNACION, SF_RAPPI"
	echo "Procesos activos..."
	ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc12/bin/SF_"
	exit 3
fi
