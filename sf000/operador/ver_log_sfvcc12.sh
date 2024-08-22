PROCESO="${1}"
case ${PROCESO} in
	SF_MPAGO)
		export LOG="/sfvcc12/tmp/sfmpago.`date +%d`.log"
		;;
esac
export i=1
if [ -f "${LOG}" ]
then
	echo "\n\n"
	until [ i -eq 5 ]
	do
		cat ${LOG}|grep MPG|grep Rta: | tail -20
		let "i = i + 1"
		sleep 2
		echo ""
		echo "ULTIMAS 20 LINEAS DEL LOG"
		echo ""
	done
else
	echo "\n\n\t\tNO EXISTE EL ARCHIVO LOG ${LOG}.\n"  
fi
echo "\n\n\t\tPresione una tecla para continuar.\c"
read 
exit
