#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Pablo Morales                                          #
# Objetivo...........: Transferir via ftps un archivo.                        #
# Nombre del programa: ftps.sh                                                #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 30/08/2013 Modificado para Pago Mis Cuentas            #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export OPER="$1"
export SERVER="$2"
export PATHORI="$3"
export ARCHORI="$4"
export PATHDES="$5"
export ARCHDES="$6"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
set -x
Check_Par 6 $@
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
		find /tarjetas/pagomiscuentas -name "cob1251*" -mtime +1 -exec gzip {} \;
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
