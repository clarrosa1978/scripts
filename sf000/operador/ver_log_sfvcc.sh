PROCESO="${1}"
case ${PROCESO} in
	SF_VCC)
		export LOG="/sfvcc/tmp/vcc.`date +%d`.log"
		;;
	SF_TOS)
		export LOG="/sfvcc/tmp/tos.`date +%d`.log"
		;;
        SF_DCC)
                export LOG="/sfvcc/tmp/dcc.`date +%d`.log"
		;;
        SF_CLIENTE)
                export LOG="/sfvcc/tmp/sfcliente.`date +%d`.log"
		;;
        SF_PUNTOS)
                export LOG="/sfvcc/tmp/sfpuntos.`date +%d`.log"
                ;;
        SF_PIM)
                export LOG="/sfvcc/tmp/sfpim.`date +%d`.log"
                ;;
        SF_DNI)
                export LOG="/sfvcc12/tmp/sfdni.`date +%d`.log"
                ;;
esac
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
