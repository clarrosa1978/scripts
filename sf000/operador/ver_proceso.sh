export PROCESO=${1}
MUESTRA="`ps -ef | grep "${PROCESO}" | grep -v grep | grep -v 'LOCAL=' | grep -v ksh | grep -v alerta`"
if [ "${MUESTRA}" ]
then
	echo "\n\n"
	echo "$MUESTRA" | awk ' { print sprintf("\t\t%s", $0)} '
else
	echo "\n\n\t\tNO EXISTEN PROCESOS ${PROCESO} ACTIVOS.\n"  
fi
echo "\n\n\t\tPresione una tecla para continuar.\c"
read 
exit
