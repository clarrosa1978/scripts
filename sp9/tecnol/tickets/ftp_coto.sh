#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: ftp_sobres.sh                                          #
# Grupo..............:                                                        #
# Autor..............: Cristian Larrosa                                       #
# Objetivo...........: Bajar via ftp el archivo de juncadella para validar    #
#                      los vales COTO.                                        #
# Nombre del programa: ftp_coto.sh                                            #
# Nombre del JOB.....: FTPCOTO                                                #
# Solicitado por.....: Soporte Storeflow                                      #
# Descripcion........:                                                        #
# Modificacion.......: 18/12/2012                                             #
###############################################################################

set -x

###############################################################################
###                            VARIABLES                                    ###
###############################################################################
export FECHA=${1}
export DIR="/tickets/coto"
export APPATH="/ftpjunca"
export ARCHCOTO="co${FECHA}.txt"
export COMMAND_FILE="/tmp/ftpcoto"
export TARGET_HOST="juncadella_ftp_site"
export FTPCOMMAND="/tecnol/bin/safe_ftp"

###############################################################################
###                            FUNCIONES                                    ###
###############################################################################
autoload Check_Par
autoload Borrar

###############################################################################
###                            PRINCIPAL                                    ###
###############################################################################
Borrar ${COMMAND_FILE}

cd ${DIR}
if [ $? != 0 ]
then
        echo "No se pudo acceder a ${DIR}."
        exit 2
fi

echo "cd ${APPATH}" > ${COMMAND_FILE}
echo "ascii" >> ${COMMAND_FILE}
echo "lcd ${DIR}" >> ${COMMAND_FILE}
echo "get ${ARCHCOTO}" >> ${COMMAND_FILE}
#echo "quit"  >> ${COMMAND_FILE}

if [ ! -s  ${COMMAND_FILE} ]
then
        echo "No se genero el archivo para procesar"
        exit 1
fi

if [ -x ${FTPCOMMAND} ]
then
	${FTPCOMMAND} "$TARGET_HOST" "" "" "$COMMAND_FILE" "$APPATH"
	STATUS="$?"
	if [ "$STATUS" != 0 ]
	then
		echo "Error en la transferencia de archivos"
		cat ${COMMAND_FILE}
	#	rm -f ${COMMAND_FILE}
		exit $STATUS
	else
		echo "Archivo ${ARCHCOTO} finalizo OK." 
	#	rm -f $COMMAND_FILE
		exit 0
	fi
else
	echo "ERROR - El comando ${FTPCOMMAND} no existe o no tiene permisos de ejecucion."
	exit 1
fi
