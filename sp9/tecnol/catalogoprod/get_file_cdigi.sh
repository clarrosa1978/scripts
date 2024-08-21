#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Transferir via http un archivo desde el sitio          #
#                      Cotodigital.                                           #
# Nombre del programa: get_file_cdigi.sh                                      #
# Nombre del JOB.....:                                                        #
# Descripcion........:                                                        #
# Modificacion.......: 18/10/2016                                             #
###############################################################################

###############################################################################
###                            Variables                                    ###
###############################################################################
export SERVER="$1"
export PATHORI="$2"
export ARCHORI="$3"
export PATHDES="$4"
export ARCHDES="$5"

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
rm -f ${PATHDES}/${ARCHDES}
/usr/bin/curl -S http://${SERVER}/${PATHORI}/${ARCHORI} -o ${PATHDES}/${ARCHDES}
EXIT_STAT="$?"
if [ "$EXIT_STAT" -ne 0 ]
then
	echo "Error - No se pudo hacer download del archivo ${ARCHORI}.\n"
        echo "Revisar el sysout y reportar a Administracion Unix.\n"
	exit 1
else
	echo "La transferencia termino Ok."
	chown root.oinstall ${PATHDES}/${ARCHDES}
	chmod 660 ${PATHDES}/${ARCHDES}
	exit 0
fi
