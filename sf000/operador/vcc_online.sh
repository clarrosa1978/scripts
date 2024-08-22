#!/usr/bin/ksh
/tecnol/operador/vcc_offline.sh
DIA="`date +%d`"
su - sfvcc -c /tecnol/sfvcc/vcc_online.sh ${DIA}
echo "\n\n\t\tPresione una tecla para continuar."
read
exit
