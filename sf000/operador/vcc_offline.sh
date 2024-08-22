#!/usr/bin/ksh
DIA="`date +%d`"
su - sfvcc -c /tecnol/sfvcc/vcc_offline.sh ${DIA}
echo "\n\n\t\tPresione una tecla para continuar.\c"
read 
exit
