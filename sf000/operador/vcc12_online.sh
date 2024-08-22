#!/usr/bin/ksh
/tecnol/operador/vcc12_offline.sh
DIA="`date +%d`"
su - sfvcc12 -c /tecnol/sfvcc12/vcc_online.sh ${DIA}
echo "\n\n\t\tPresione una tecla para continuar."
read
exit
