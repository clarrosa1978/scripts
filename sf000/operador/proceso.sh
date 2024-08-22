#set -x
PROCESO="${1}"
function Esta
{
#set -x
        typeset PROCESO="${1}"
        typeset EXIT="1"
       	PROC="`ps -fu sfctrl | grep -v grep | grep ${PROCESO}`"
        if [ "${PROC}" ]
	then
		EXIT="0"
	fi
        return ${EXIT}
}

function Continuar
{
	tput ed
	echo  "\t\t${REV}Presione una tecla para continuar...${EREV}"
	read
}


Esta "${PROCESO}"
if [ $? = 0 ]
then
	echo "\t\tBajando proceso ${PROCESO}\n"
	ps -fu sfctrl | grep -v grep | grep ${PROCESO} | awk ' { print $2 } ' | xargs -i kill -15 {}
	Esta "${PROCESO}"
        if [ $? = 0 ]
	then
		echo "ERROR - No se pudo bajar el proceso ${PROCESO}\n"
		Continuar
	fi
fi
su - sfctrl -c "${PROCESO}"
Esta "${PROCESO}"
if [ $? = 1 ]
then
	echo "\t\tERROR - No se pudo levantar el proceso ${PROCESO}\n"
else
	echo "\t\tPROCESO ${PROCESO} iniciado correctamente\n"
fi
Continuar
