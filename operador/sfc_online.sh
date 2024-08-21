#!/usr/bin/ksh
set -x
DIA="`date +%d`"
ESTA="`ps -ef | grep SF_CLIENDO | grep -v grep`"
if [ "${ESTA}" ]
then
        echo "\n\n\t\t\tEl proceso ya esta ACTIVO.\n"
else    
        sudo -u sfcliendo -i "/tecnol/sfcliendo/sfc_online.sh ${DIA}"
	ESTA=""
	ESTA="`ps -ef | grep SF_CLIENDO | grep -v grep`"
	if [ "${ESTA}" ]
	then
		echo "\n\n\t\t\tEl proceso ahora esta ACTIVO.\n"
	else
        	echo "\n\n\t\t\tEl proceso no se puede ACTIVAR. Avisar a Storeflow.\n"
	fi
fi
