#!/usr/bin/ksh
set -x
DIA="`date +%d`"
ESTA="`ps -ef | grep SF_CLIENDO | grep -v grep | grep -v 'LOCAL='`"
if [ "${ESTA}" ]
then
	echo "\n\n\t\t\tEl proceso esta ACTIVO - Matando.....\n"
	sudo -u sfcliendo -i  "/tecnol/sfcliendo/sfc_offline.sh ${DIA}"
	ESTA=""
	ESTA="`ps -ef | grep SF_CLIENDO | grep -v grep| grep -v 'LOCAL='`"
	if [ ! "${ESTA}" ]
	then
		echo "\n\n\t\t\tEl proceso ahora esta INACTIVO.\n"
        else
		echo "\n\n\t\t\t${ESTA}\n"
                echo "\n\n\t\t\tEl proceso no se puede BAJAR. Matar en forma MANUAL.\n"
        fi
else	
	echo "\n\n\t\t\tEl proceso no esta ACTIVO.\n"
fi
