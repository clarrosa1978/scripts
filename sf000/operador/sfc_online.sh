#!/usr/bin/ksh
/tecnol/operador/sfc_offline.sh
DIA="`date +%d`"
	su - sfcliendo -c /tecnol/sfcliendo/sfc_offline.sh
        su - sfcliendo -c /tecnol/sfcliendo/sfc_online.sh ${DIA}
	ESTA=""
	ESTA="`ps -ef | grep SF_CLIENDO | grep -v grep`"
	if [ "${ESTA}" ]
	then
		echo "\n\n\t\t\tEl proceso ahora esta ACTIVO.\n"
	else
        	echo "\n\n\t\t\tEl proceso no se puede ACTIVAR. Avisar a Storeflow.\n"
	fi
echo "\n\n\t\tPresione una tecla para continuar."
read
exit
