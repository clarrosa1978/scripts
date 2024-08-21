#!/usr/bin/ksh
set -x
DIA="`date +%D`"
OK="TRUE"
function CHK_PROCESOS
{
        for PR in SF_CLIENTE SF_TOS SF_DCC SF_VCC
        do
                ESTA="`ps -ef | grep ${PR} | grep -v grep | grep -v 'LOCAL='`"
                if [ "${ESTA}" ]
                then
                        echo "\n\n\t\t\tEl proceso ${PR} esta ACTIVO."
                else
                        echo "\n\n\t\t\tEl proceso ${PR} esta INACTIVO."
                        OK="FALSE"
                fi
        done
        if [ ${OK} = "FALSE" ]
        then
                return 1
        else
                return 0
        fi
}

CHK_PROCESOS
if [ $? = 0 ]
then
        echo "\n\n\t\t\tHay procesos ACTIVOS.\n"
else
	sudo -u sfvcc "/tecnol/sfvcc/vcc_online.sh ${DIA}"
        CHK_PROCESOS
	if [ $? = 0 ]
	then
		echo "\n\n\t\t\tLos procesos estan ACTIVOS.\n"
	else
		echo "\n\n\t\t\tHay procesos INACTIVOS - Revisar.\n"
	fi
fi
echo "\n\n\t\tPresione una tecla para continuar.\c"
read tecla
exit
