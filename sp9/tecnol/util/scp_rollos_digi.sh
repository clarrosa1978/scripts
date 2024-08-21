#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: PRECIOS-GDM-TEST                                       #
# Grupo..............: TRANSFERENCIA                                          #   
# Autor..............: Gustavo Alonso                                         #
# Objetivo...........: COPIA NOVEDADES DE PRECIOS A TESTING                   #
# Nombre del programa: scp_nov_test.sh                                        #
# Nombre del JOB.....: SCPNOVXXX                                              #
# Solicitado por.....:                                                        #
# Descripcion........:                                                        #
# Creacion...........: 24/07/2018                                             #
# Modificacion.......: 24/07/2018                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export HOST_ORI="${2}"
export SOURCE_DES="${3}"
export SOURCE_ORI="/sfctrl/rdigital"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log

###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 3 $@
if [ $? != 0 ]
then
        echo "Falta ingresar uno o mas parametros de ejecucion."
        exit 1
fi

	ssh ${HOST_ORI} "cd ${SOURCE_ORI}"
	if [ $? != 0 ]
	then
       		echo "No se pudo acceder al directorio ${SOURCE_ORI}"
		exit 1
        else
        	SOURCE_FILE="$(ssh ${HOST_ORI} "cd ${SOURCE_ORI} ; ls -1rt rollo.????.${FECHA}.*")"
        	if [ ! "${SOURCE_FILE}" ]
        	then
                	echo "No hay archivos para transferir."
                	exit 4
        	else
			for ARCH in ${SOURCE_FILE}
			do
			scp -pr ${HOST_ORI}:${SOURCE_ORI}/${ARCH} ${SOURCE_DES}
	                EXIT=$?
                		case ${EXIT} in
                        	0 )     echo "AVISO - TRANSFERENCIA DEL ARCHIVO ${SOURCE_FILE} FINALIZO CORRECTAMENTE."
                                	;;
                        	* )     echo "ERROR - NO DETERMINADO DURANTE LA TRANSFERENCIA."
                                	exit 1
                                	;;
                		esac
        		done
		fi
	
	echo "FINALIZO CORRECTAMENTE LA TRANFERENCIA DE LOS ARCHIVOS."
	exit 0
	fi


