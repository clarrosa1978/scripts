export LOG="/sfcliendo/tmp/sfcliendo.`date +%d`.log"
export i=1
if [ -f "${LOG}" ]
then
	echo "\n\n"
	until [ i -eq 5 ]
	do
		tail -10  ${LOG} | awk ' { print sprintf("\t\t%s", $0)} '
		let "i = i + 1"
		sleep 2
	done
else
	echo "\n\n\t\tNO EXISTE EL ARCHIVO LOG ${LOG}.\n"  
fi
echo "\n\n\t\tPresione una tecla para continuar.\c"
read 
exit
