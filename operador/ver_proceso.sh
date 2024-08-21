export PROCESO=${1}
MUESTRA="`ps -ef | grep "${PROCESO}" | grep -v grep | grep -v 'LOCAL=' | grep -v ksh`"
echo "\n\n\t\t\t${MUESTRA}\n"
echo "\n\n\t\tPresione una tecla para continuar.\c"
read tecla
exit
