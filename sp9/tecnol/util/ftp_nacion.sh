#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Transferir via ftp un archivo.                         #
# Nombre del programa: ftp.sh                                                 #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 15/10/2013                                             #
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
		#/usr/bin/curl -k --netrc -v ftp://${SERVER}/${PATHORI}/${ARCHORI} -o ${PATHDES}/${ARCHDES}
		/usr/bin/curl --disable-eprt -n -k -v -i -u Coto:2019LNClub ftps://${SERVER}/${PATHORI}/${ARCHORI} -o ${PATHDES}/${ARCHDES} 

		
	else
		#/usr/bin/curl -k --netrc -v ftp://${SERVER}/${ARCHORI} -o ${PATHDES}/${ARCHDES}
		/usr/bin/curl --disable-eprt -n -k -v -i -u Coto:2019LNClub ftps://${SERVER}/${ARCHORI} -o ${PATHDES}/${ARCHDES}
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
		#/usr/bin/curl -v -u Coto:Covedisa2012 -T ${PATHORI}/${ARCHORI} ftp://${SERVER}/${PATHDES}/${ARCHDES}
	        /usr/bin/curl --disable-eprt -n -k -v -i -u Coto:2019LNClub -T ${PATHORI}/${ARCHORI} ftps://${SERVER}/${PATHDES}/${ARCHDES}
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