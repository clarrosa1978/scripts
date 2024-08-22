#!/usr/bin/ksh
#################################################################################
#                                                                               #
#                                                                               #
#  SCRIPT PARA SUBIR LOS DEMONIOS                                               #
#  DEL VERIFICADOR CENTRAL COTO (VCC)                                           #
#                                                                               #
#################################################################################
#set -x

USUARIO=sfvcc
CANTIDAD=4              #Cantidad de procesos SF_* que deben estan activos
DIA=${1}
if [ -z "$2" ]
then
APP="ALL"
else
APP=${2}
fi

#Chequeo log
#ffor archivo in tos vcc dcc sfcliente
#do
#        if [ -s /sfvcc/tmp/${archivo}.${DIA}.log.Z ]
#        then
#                compress -d -f /sfvcc/tmp/${archivo}.${DIA}.log || exit 3
#        fi
#done

echo "Verifico que no existan Files .LCK"
#************************************
#* LEVANTA LOS PROCESOS DE VCC      *
#************************************
if [[ $APP == "ALL" ]]
then
/tecnol/sfvcc/vcc_offline.sh ${DIA} ALL
/sfvcc/bin/SF_VCC
/sfvcc/bin/SF_TOS
/sfvcc/bin/SF_DCC
/sfvcc/bin/SF_CLIENTE
/sfvcc/bin/SF_PUNTOS
/sfvcc/bin/SF_MILLAS
else
/tecnol/sfvcc/vcc_offline.sh ${DIA} ${APP}
/sfvcc/bin/${APP}
fi

#CONTROL de PROCESOS ACTIVOS

CUENTA=""

if [[ $APP == "ALL" ]]
then
CUENTA=$(ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_" | wc -l)

[ ${CUENTA} ] &&  VACIA="FALSE" || VACIA="TRUE"
if [ $VACIA != "TRUE" ] && [ $CUENTA -eq $CANTIDAD ]
then
        echo "LOS ${CANTIDAD} PROCESOS de VCC estan ACTIVOS"
        ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_"
else
        echo "Atencion NO LEVANTARON LOS {CANTIDAD} PROCESOS de VCC"
        echo "SF_VCC, SF_TOS, SF_DCC, SF_CLIENTE, SF_PUNTOS, SF_MILLAS"
        echo "Procesos activos..."
        ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/SF_"
        exit 3
fi
else
CUENTA=$(ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/$APP" | wc -l)
CANTIDAD=1
[ ${CUENTA} ] &&  VACIA="FALSE" || VACIA="TRUE"
if [ $VACIA != "TRUE" ] && [ $CUENTA -eq $CANTIDAD ]
then
        echo "EL ${CANTIDAD} PROCESO de $APP esta ACTIVOS"
        ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/$APP"
        exit 0
else
        echo "Atencion NO LEVANTO UN ${CANTIDAD} PROCESO de $APP"
        echo "SF_VCC, SF_TOS, SF_DCC, SF_CLIENTE, SF_PUNTOS, SF_MILLAS"
        echo "Procesos activos..."
        ps -ef | grep ${USUARIO} | grep -v grep | grep "/sfvcc/bin/$APP"
        exit 3
fi
fi
