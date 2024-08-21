#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: Transferir via ftps el archivo liq1251.                #
# Nombre del programa: ftps.sh                                                #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export NODAY=$1
export OPER=$2
export SERVER="$3"
export PATHORI="$4"
export PATHDES="$5"

/usr/bin/curl --disable-eprt -n -k --ftp-ssl ftps://${SERVER}/${PATHORI}/ --list-only | grep "LIQ1251" | egrep "${NODAY}" > /tmp/liq1251.tmp 

for ARCH in $(cat /tmp/liq1251.tmp)
do
export ARCHORI=$ARCH
export ARCHDES=$ARCH
done

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
set -x
Check_Par 5 $@
if [ $? != 0 ] 
then
	echo "Error en la cantidad de parametro.\n"
	echo "Utilizar ftp.sh Operacion Server PathOrigen ArchiveOrigen PathDestino ArchivoDestino.\n"
	exit 1
fi
if [ ! -x /usr/bin/curl ]
then
	echo "Error - El comando curl no existe o no hay permisos de ejecucion."
	exit 1
fi
if [ ${OPER} = "G" ]
then
	if [ ${PATHORI} != 'NULL' ]
	then
		/usr/bin/curl --disable-eprt -n -k --ftp-ssl ftps://${SERVER}/${PATHORI}/${ARCHORI} -o ${PATHDES}/${ARCHDES}
	else
		/usr/bin/curl --disable-eprt -n -k  --ftp-ssl ftps://${SERVER}/${ARCHORI} -o ${PATHDES}/${ARCHDES}
	fi
	EXIT_STAT="$?"
        if [ "$EXIT_STAT" -ne 0 ]
        then
		echo "Error - No se pudo hacer download del archivo ${ARCHORI}.\n"
                echo "Revisar el sysout y reportar a Administracion Unix.\n"
		exit 1
	else
		echo "La transferencia termino Ok."
                exit 0
        fi
else
	if [ ${OPER} = "P" ]
	then
		/usr/bin/curl --disable-eprt -T ${PATHORI}/${ARCHORI} -n -k --ftp-ssl ftps://${SERVER}/${PATHDES}/${ARCHDES}
		EXIT_STAT="$?"
		if [ "$EXIT_STAT" -ne 0 ]
        	then
			echo "Error - No se pudo hacer upload del archivo ${ARCHDEST}.\n"
                	echo "Revisar el sysout y reportar a Administracion Unix.\n"
			exit 1
		else
			echo "La transferencia termino Ok."
                	exit 0
		fi
	else
		echo "Error - El parametro ${OPER} no es aceptado por este comando.\n"
		exit 1
	fi
fi
