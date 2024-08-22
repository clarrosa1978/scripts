#!/usr/bin/ksh
DIA="`date +%d`"
su - sfvcc12 -c /tecnol/sfvcc12/vcc_offline.sh ${DIA}
echo "\n\n\t\tPresione una tecla para continuar.\c"
read 
exit
