#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Transferir via sftp un archivo.                        #
# Nombre del programa: sftp.sh                                                #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 13/06/2011                                             #
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
export USER="AdherenteCoto"
export PASS="C070spc4"

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
		/usr/bin/curl -v -n -k -u ${USER}:${PASS} sftp://${SERVER}/${PATHORI}/${ARCHORI} -o ${PATHDES}/${ARCHDES}
	else
		/usr/bin/curl -v -n -k -u ${USER}:${PASS} sftp://${SERVER}/${ARCHORI} -o ${PATHDES}/${ARCHDES}
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
		if [ ${PATHDES} != 'NULL' ]	
		then
			/usr/bin/curl -T ${PATHORI}/${ARCHORI} -v -n -k -u ${USER}:${PASS} ftps://${SERVER}/${PATHDES}/${ARCHDES}
		else
			/usr/bin/curl -T ${PATHORI}/${ARCHORI} -v -n -k -u ${USER}:${PASS} ftps://${SERVER}/${ARCHDES}
		fi
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
