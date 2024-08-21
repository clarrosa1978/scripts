#!/usr/bin/ksh
###############################################################################
# Aplicacion.........:                                                        #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Descomprimir un archivo con el comando zip.            #
# Nombre del programa: descomprimir.sh                                        #
# Nombre del JOB.....:                                                        #
# Descripcion........: Recibe como parametro el archivo con el path absoluto  #
#                      del archivo a descomprimir.                            #
# Modificacion.......: 07/09/2006                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export ARCHIVO_ORI=${1}
export ARCHIVO_DES=${2}

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Check_Par
	
###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 2 "$@"
if [ $? = 0 ] 
then
	if [ -s ${ARCHIVO_ORI} ]
	then
       		/usr/bin/unzip -p ${ARCHIVO_ORI} >${ARCHIVO_DES} 
       		[ $? = 0 ] && exit 0
	else
		exit 12
	fi
else
	exit 1
fi
