#!/usr/bin/ksh
DIA="`date +%d`"
su - sfvcc12 -c /tecnol/sfvcc12/vcc12_online.sh ${DIA} ${1}
echo "\n\n\t\tPresione una tecla para continuar.\c"
read
exit

