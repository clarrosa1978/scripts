#!/usr/bin/ksh
###############################################################################
# Aplicacion.........: CARTACRED                                              #
# Grupo..............: NOVED-LISTA-NEGRA                                      #
# Autor..............: Ignacio Bellucci                                       #
# Objetivo...........: Realiza sftp hacia sitio CARTACRED para bajar crudo    #
# Nombre del programa: sftp_cartacred.sh                                      #
# Nombre del JOB.....: DOWNLOAD_CARTACRED                                     #
# Solicitado por.....: Cristian Larrosa                                       #
# Descripcion........:                                                        #
# Modificacion.......: 11/11/2019                                             #
###############################################################################

set -x

###############################################################################
###                            Variables                                    ###
###############################################################################
export FECHA="${1}"
export NOMBRE="sftp_cartacred"
export PATHAPL="/tecnol/cartacred/file"
export PATHLOG="${PATHAPL}/log"
export LOG="${PATHLOG}/${NOMBRE}.${FECHA}.log"
export HOST=sftp.credencial.com.ar
export USER=clarrosa
export KEY="/tecnol/cartacred/id_rsa"
export LOCALDIR="/tarjetas/cartacred/crudos"
export ARCHIVOR="Full.txt"
export ARCHIVO="full.txt"

###############################################################################
###                            Funciones                                    ###
###############################################################################
autoload Borrar
autoload Check_Par
autoload Enviar_A_Log


###############################################################################
###                            Principal                                    ###
###############################################################################
Check_Par 1 $@
[ $? != 0 ] && exit 1
Enviar_A_Log "INICIO - Comienza sftp ArgenCard" ${LOG}
[ $? != 0 ] && exit 3
Borrar ${LOG}
echo "Descargando archivo de CartaCred"
sleep 1
rm ${PATHAPL}/*.txt
echo "borre el archivo"
sftp -i ${KEY} ${USER}@${HOST}:/ARCHIVOS/BOLETIN/${ARCHIVOR} ${PATHAPL}
if [ $? = 0 ]
then
	ESTA="`ls -1 ${PATHAPL}/${ARCHIVOR} | tail -1`"
	if [ "${ESTA}" ]
	then
			cp -p "${PATHAPL}/${ARCHIVOR}" "${LOCALDIR}/${ARCHIVO}" && chmod 644 ${LOCALDIR}/${ARCHIVO}
			if [ $? = 0 ]
			then
 				Enviar_A_Log "PROCESO - El archivo ${LOCALDIR}/${ARCHIVO} se cambio bien." ${LOG}
                        	Enviar_A_Log "FIN - Finalizacion OK." ${LOG}
                        	exit 0
			else
				Enviar_A_Log "ERROR - No se encontro el archivo ${ARCHIVO} en el sitio ftp." ${LOG}
                        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOG}
                        	exit 1
			fi
	else
		Enviar_A_Log "ERROR - No se encontro el archivo" ${LOG}
        	Enviar_A_Log "FINALIZACION - CON ERRORES." ${LOG}
        	exit 9
	fi
else
	echo "Error al conectarse al sitio sftp de ArgenCard"
	exit 14
fi
